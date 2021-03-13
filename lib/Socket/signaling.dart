import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meet_up/Socket/random_string.dart';
import '../Socket//websocket.dart'
    if (dart.library.js) '../Socket/websocket_web.dart';
import 'SharedManaged.dart';
import 'device_info.dart';

enum SignalingState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

/*
 * callbacks for Signaling API.
 */
typedef void SignalingStateCallback(SignalingState state);
typedef void StreamStateCallback(MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void DataChannelMessageCallback(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RTCDataChannel dc);

class Signaling {
  String _selfId = randomNumeric(6);
  SimpleWebSocket _socket;
  var _sessionId;
  var _peerConnections = new Map<String, RTCPeerConnection>();
  var _dataChannels = new Map<String, RTCDataChannel>();
  var _remoteCandidates = [];

  var userId;
  var toId;
  var enquiryId;
  var iat = DateTime.now();
  var exp =
      DateTime(DateTime.now().year + 1, DateTime.now().month).toIso8601String();

  var roomName = '${SharedManager.shared.meetingID}';

  MediaStream _localStream;
  List<MediaStream> _remoteStreams;
  SignalingStateCallback onStateChange;
  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  OtherEventCallback onPeersUpdate;
  OtherEventCallback onMessageRequest;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;

//Optional Constraint

  // final Map<String, dynamic> _dcConstraints = {
  //   'mandatory': {
  //     'OfferToReceiveAudio': false,
  //     'OfferToReceiveVideo': false,
  //   },
  //   'optional': [],
  // };

  Signaling({this.enquiryId, this.userId, this.toId = "2"});
  send(event, data) {
    data['type'] = event;
    SharedManager.shared.manager.send('join', data);
  }

  sendTest(event, data) {
    data['type'] = event;
    _socket.send(data);
  }

  close() {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }

    _peerConnections.forEach((key, pc) {
      pc.close();
    });
    if (_socket != null) _socket.close();
  }

//MARK: Switch Camera
  void switchCamera() {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].switchCamera();
    }
  }

//MARK: Mute/Unmute Audio
  void muteAudio(bool status) {
    _peerConnections.forEach((key, pc) {
      if (status) {
        _localStream.getAudioTracks()[0].enabled = true;
      } else {
        _localStream.getAudioTracks()[0].enabled = false;
      }
    });
  }

//MARK: Speaker on/off

  void speakerMode(bool status) {
    _localStream.getAudioTracks()[0].enableSpeakerphone(status);
  }

//MARK: Mute/Unmute Video
  void hideVideo(bool status) {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].enabled = status;
    }
  }

  void invite(String peerid, String media, usescreen) {
    this._sessionId = this._selfId + '-' + peerid;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateNew);
    }
  }

  void sendMessage(String messageString) {
    SharedManager.shared.manager.send('message', {'message': '$messageString'});
  }

  void bye() {
    SharedManager.shared.manager.send('leave', {
      'type': 'leave',
    });
  }

  void connect() async {
    print('connect metode called from the signaling state');

    await SharedManager.shared.manager.initSocket();

    SharedManager.shared.manager.onOpen = () {
      print('onOpen');
      this?.onStateChange(SignalingState.ConnectionOpen);
      checkRoom();
    };

    SharedManager.shared.manager.onMessage = (message) {
      print('Recivied data: ' + message);
      JsonDecoder decoder = new JsonDecoder();
      this.onMessage(decoder.convert(message));
    };

    SharedManager.shared.manager.onClose = (int code, String reason) {
      print('Closed by server [$code => $reason]!');
      if (this.onStateChange != null) {
        this.onStateChange(SignalingState.ConnectionClosed);
      }
    };

    await SharedManager.shared.manager.socket.connect();
  }

  receivedMessage(dynamic data) {
    JsonDecoder decoder = new JsonDecoder();
    this.onMessage(decoder.convert(data));
  }

  void checkRoom() async {
    print('You are checking the room is empty or not');
    SharedManager.shared.manager
        .send('checkRoom', {"type": "checkRoom", "room": roomName});
  }

  void onMessage(message) async {
    Map<String, dynamic> mapData = message;
    var data = mapData['data'];
    print('Final Data Type:${mapData['type']}');
    switch (mapData['type']) {
      case 'login':
        bool flag = mapData["success"] ?? false;
        if (flag) {
          _createPeerConnection('2', 'video', false).then((pc) {
            _peerConnections['2'] = pc;
          });
        }
        break;
      case 'checkRoomResult':
        bool flag = mapData["result"] ?? false;
        if (flag) {
          print('Join the room first');
          //type:join
          SharedManager.shared.manager
              .send('join', {'type': 'join', 'room': roomName});
        }
        break;
      case 'join':
        var id = "2";
        var media = "video";
        var pc = await _createPeerConnection(id, media, false);
        _peerConnections['2'] = pc;
        speakerMode(true);
        if (this.onStateChange != null) {
          this.onStateChange(SignalingState.CallStateNew);
        }

        _createOffer('2', _peerConnections['2'], 'video');
        break;
      case 'notification':
        break;
      case 'peers':
        {
          List<dynamic> peers = data;
          if (this.onPeersUpdate != null) {
            Map<String, dynamic> event = new Map<String, dynamic>();
            event['self'] = _selfId;
            event['peers'] = peers;
            this.onPeersUpdate(event);
          }
        }
        break;
      case 'offer':
        {
          var id = "2";
          var description = mapData['sdp'];
          var media = "video";
          // var sessionId = data['session_id'];
          // this._sessionId = sessionId;

          if (this.onStateChange != null) {
            this.onStateChange(SignalingState.CallStateNew);
          }

          var pc = await _createPeerConnection(id, media, false);
          _peerConnections['2'] = pc;

          await _peerConnections['2'].setRemoteDescription(
              new RTCSessionDescription(
                  description['sdp'], description['type']));
          print("final check _peerConnections await");

          await _createAnswer(id, _peerConnections['2'], media);

          if (this._remoteCandidates.length > 0) {
            _remoteCandidates.forEach((candidate) async {
              await _peerConnections['2'].addCandidate(candidate);
            });
            _remoteCandidates.clear();
          }
        }
        break;
      case 'answer':
        {
          var description = mapData['answer'];
          await _peerConnections['2'].setRemoteDescription(
              new RTCSessionDescription(description['sdp'],
                  description['type'].toString().toLowerCase()));
        }
        break;
      case 'candidate':
        {
          var candidateMap = mapData["candidate"];
          // var pc = _peerConnections['2'];
          RTCIceCandidate candidate = new RTCIceCandidate(
              candidateMap['candidate'],
              candidateMap['sdpMid'],
              candidateMap['sdpMLineIndex']);
          await _peerConnections['2'].addCandidate(candidate);

          if (_peerConnections['2'] != null) {
          } else {
            _remoteCandidates.add(candidate);
          }
        }
        break;
      case 'leave':
        {
          var pc = _peerConnections.remove('2');
          _dataChannels.remove('2');

          if (_localStream != null) {
            _localStream.dispose();
            _localStream = null;
          }

          if (pc != null) {
            pc.close();
          }
          this._sessionId = null;
          if (this.onStateChange != null) {
            this.onStateChange(SignalingState.CallStateBye);
          }
        }
        break;
      case 'bye':
        {
          var to = data['to'];
          var sessionId = data['session_id'];
          print('bye: ' + sessionId);

          if (_localStream != null) {
            _localStream.dispose();
            _localStream = null;
          }

          var pc = _peerConnections['2'];
          if (pc != null) {
            pc.close();
            _peerConnections.remove('2');
          }

          var dc = _dataChannels[to];
          if (dc != null) {
            dc.close();
            _dataChannels.remove(to);
          }

          this._sessionId = null;
          if (this.onStateChange != null) {
            this.onStateChange(SignalingState.CallStateBye);
          }
        }
        break;
      case 'keepalive':
        {
          print('keepalive response!');
        }
        break;
      case "requestMessage":
        {
          // print("Message Request Data:$onMessageRequest");
          Map<String, dynamic> event = new Map<String, dynamic>();
          event['self'] = _selfId;
          event['requestMessage'] = data;
          this.onMessageRequest(event);
        }
        break;
      case "message":
        {
          print("Message Request Data:${mapData['message']}");
          Map<String, dynamic> event = new Map<String, dynamic>();
          event['type'] = 'message';
          event['message'] = '${mapData['message']}';
          this.onMessageRequest(event);
        }
        break;
      case "acceptReject":
        {
          print("Message Request Data:$onMessageRequest");
          Map<String, dynamic> event = new Map<String, dynamic>();
          event['type'] = "acceptReject";
          event['acceptReject'] = data;
          this.onMessageRequest(event);
        }
        break;
      case "call":
        {
          print("Message Request Data:$onMessageRequest");
          Map<String, dynamic> event = new Map<String, dynamic>();
          event['type'] = 'call';
          event['call'] = data;
          this.onMessageRequest(event);
        }
        break;
      case "typing":
        {
          print("Message Request Data:$onMessageRequest");
          Map<String, dynamic> event = new Map<String, dynamic>();
          event['type'] = 'typing';
          event['typing'] = data;
          this.onMessageRequest(event);
        }
        break;
      default:
        break;
    }
  }

  void requestForAcceptRejectCall(
      String acceptRejectfrom,
      String acceptRejectfromTo,
      String acceptRejectfromName,
      String acceptRejectToName,
      String acceptRejectType,
      String callType) async {
    SharedManager.shared.manager.send('acceptReject', {
      'acceptRejectFromId': acceptRejectfrom,
      'acceptRejectToId': acceptRejectfromTo,
      'acceptRejectFromname': acceptRejectfromName,
      'acceptRejectToName': acceptRejectToName,
      "acceptRejectType": acceptRejectType,
      "callType": callType,
      //'0 -> accept, 1-> reject'
    });
    //  sendDetailsOfExistingUser();
  }

  void requestForCalling(String callFrom, String callTo, String callFromName,
      String callToName, String callType) async {
    SharedManager.shared.manager.send('call', {
      'callFromId': callFrom,
      'callToId': callTo,
      'callFromName': callFromName,
      'callToName': callToName,
      'callType': callType
    });
    //  sendDetailsOfExistingUser();
  }

  void requestForTyping(
      String typingFrom, String typingTo, String typingFromName) async {
    SharedManager.shared.manager.send('typing', {
      'typingFromId': typingFrom,
      'typingToId': typingTo,
      'typingFromName': typingFromName
    });
    //  sendDetailsOfExistingUser();
  }

  void requestForChat(
      String fromId, String toId, String fromName, String toName) async {
    // print('Socket Connection Status:${_socket.toString()}');
    print('Socket Connection is open');
    SharedManager.shared.manager.send('requestMessage', {
      'fromName': fromName,
      'toName': toName,
      'fromId': fromId,
      'toId': toId,
    });
    //  sendDetailsOfExistingUser();
  }

  // void sendMessage(String fromId, String toId, String time, String message,
  //     String imgString, String type) async {
  //   SharedManager.shared.manager.send('message', {
  //     'fromId': fromId,
  //     'toId': toId,
  //     'time': time,
  //     'message': message,
  //     'imgString': imgString,
  //     'msgType': type
  //   });
  //   // sendDetailsOfExistingUser();
  // }

  void sendDetailsOfExistingUser() {
    SharedManager.shared.manager.send('new', {
      'name': SharedManager.shared.name,
      "typeUser": SharedManager.shared.mobile,
      "isDoctor": SharedManager.shared.isDoctor ? "1" : "0",
      "role": SharedManager.shared.specility,
      'id': _selfId,
      'user_agent': DeviceInfo.userAgent
    });
  }

  Future<MediaStream> createStream(media, userscreen) async {
    if (media == "video") {
      Map<String, dynamic> mediaConstraints = {
        'audio': true,
        'video': {
          'mandatory': {
            'minWidth':
                '640', // Provide your own width, height and frame rate here
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'facingMode': 'user',
          'optional': [],
        }
      };
      MediaStream stream = userscreen
          ? await navigator.getDisplayMedia(mediaConstraints)
          : await navigator.getUserMedia(mediaConstraints);
      if (this.onLocalStream != null) {
        this.onLocalStream(stream);
      }
      return stream;
    } else {
      Map<String, dynamic> mediaConstraints = {'audio': true, 'video': true};
      MediaStream stream = userscreen
          ? await navigator.getDisplayMedia(mediaConstraints)
          : await navigator.getUserMedia(mediaConstraints);
      if (this.onLocalStream != null) {
        this.onLocalStream(stream);
      }
      return stream;
    }
  }

  _createPeerConnection(id, media, userscreen) async {
    if (media != 'data') _localStream = await createStream(media, userscreen);
    RTCPeerConnection pc = await createPeerConnection(
        SharedManager.shared.iceServers, SharedManager.shared.config);
    if (media != 'data') pc.addStream(_localStream);
    pc.onIceCandidate = (candidate) {
      SharedManager.shared.manager.send('candidate', {
        'to': id,
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
        'session_id': this._sessionId,
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onAddStream = (stream) {
      if (this.onAddRemoteStream != null) this.onAddRemoteStream(stream);
      //_remoteStreams.add(stream);
    };

    pc.onRemoveStream = (stream) {
      if (this.onRemoveRemoteStream != null) this.onRemoveRemoteStream(stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc.onDataChannel = (channel) {
      _addDataChannel(id, channel);
    };

    return pc;
  }

  _addDataChannel(id, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage(channel, data);
    };
    _dataChannels[id] = channel;

    if (this.onDataChannel != null) this.onDataChannel(channel);
  }

  _createOffer(String id, RTCPeerConnection pc, String media) async {
    try {
      RTCSessionDescription s =
          await pc.createOffer(SharedManager.shared.constraints);
      pc.setLocalDescription(s);
      SharedManager.shared.manager.send('offer', {
        'userName': 'Hardik',
        'room': roomName,
        'sdp': {'sdp': s.sdp, 'type': 'offer'},
        'type': "offer",
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _createAnswer(String id, RTCPeerConnection pc, media) async {
    try {
      print("final check _createAnswer");
      RTCSessionDescription s =
          await pc.createAnswer(SharedManager.shared.constraints);
      pc.setLocalDescription(s);
      SharedManager.shared.manager.send('answer', {
        'room': roomName,
        'answer': {'sdp': s.sdp, 'type': s.type.toString().toLowerCase()},
        'type': 'answer',
      });
    } catch (e) {
      print("final check catch");
      print(e.toString());
    }
  }
}
