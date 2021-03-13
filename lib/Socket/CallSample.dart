import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meet_up/Helper/CommonWidgets.dart';
import 'package:meet_up/Helper/Constant.dart';
import 'package:meet_up/Helper/SocketConnection.dart';
import 'package:meet_up/Socket/SharedManaged.dart';
import 'package:meet_up/Socket/signaling.dart';
import 'package:screen/screen.dart';
import 'package:bubble/bubble.dart';

class CallSample extends StatefulWidget {
  static String name = '/CallSample';
  @override
  _CallSampleState createState() => _CallSampleState();
}

class _CallSampleState extends State<CallSample> {
  Signaling _signaling;
  var _selfId;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  bool _inCalling = false;
  bool _isMute = false;
  bool _isMsgBtn = false;
  int _isreadMsg = 0;
  bool _isHideVideo = false;
  bool _isSpeakerMode = true;
  bool _isHideBottomView = false;
  String callType = "";
  File image;
  Timer _timer;
  String imageBase64;
  String typeStringMsg = "";
  String callingName = "${SharedManager.shared.userName}";
  SocketManager manager = SocketManager();
  final _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Message> messageList = [];

  @override
  initState() {
    super.initState();
    Screen.keepOn(true);
    initRenderers();
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    if (_signaling != null) _signaling.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    Screen.keepOn(false);
  }

  disposeMethod() {
    print('disposed method called');
    SharedManager.shared.manager.disconnect();
    // manager.disconnect();
  }

  void _connect() async {
    if (_signaling == null) {
      _signaling = new Signaling(enquiryId: '1', userId: '123')..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _inCalling = true;
              _startTimer();
            });
            break;
          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              // _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;
          case SignalingState.CallStateInvite:
            print("=================>Invite State");
            _invitePeer(context, 'video', '2', false);
            break;
          case SignalingState.CallStateConnected:
            print("=================>Connected State");
            break;
          case SignalingState.CallStateRinging:
            print("=================>Ringing State");
            break;
          case SignalingState.ConnectionClosed:
            print("=================>Connection Closed State");
            break;
          case SignalingState.ConnectionError:
            print("=================>Error Connection State");
            break;
          case SignalingState.ConnectionOpen:
            print("=================>Open Connection State");
            // _signaling.speakerMode(true);
            // _signaling.send('checkRoom', {
            //   'room': 'RoomHardik',
            // });
            // _signaling.sendTest('test', {
            //   'room': 'testApp',
            // });
            break;
            break;
        }
      };

      _signaling.onDataChannelMessage = ((context, data) {
        print("Data message:------->$data");
      });

      _signaling.onMessageRequest = ((event) async {
        print("Event received on Call Sample Screen:$event");
        //this is for the message section

        Message msg = Message('${event['message']}', '1');
        this.messageList.add(msg);

        print('Message list count:$_isMsgBtn');
        if (!_isMsgBtn) {
          this._isreadMsg = 1;
          setState(() {});
        } else {
          setState(() {});
          this.scrollToBottom();
          final type = event['type'];
          if (type == 'call') {
            if (event['call']['callToId'].toString() ==
                this._selfId.toString()) {
              // calling screen
              //call type
              this.callType = event['call']['callType'].toString();
              this.callingName = event['call']['callFromName'].toString();
            }
          }
        }
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
        print(stream.getVideoTracks().toString() + "streams");
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  _invitePeer(context, mediaTye, peerId, usescreen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling.invite(peerId, mediaTye, usescreen);
    }
  }

  _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _hideVideo() {
    if (_isHideVideo) {
      _signaling.hideVideo(true);
      _isHideVideo = false;
    } else {
      _signaling.hideVideo(false);
      _isHideVideo = true;
    }
  }

  _muteMic() {
    if (_isMute) {
      _signaling.muteAudio(true);
      _isMute = false;
    } else {
      _signaling.muteAudio(false);
      _isMute = true;
    }
  }

  _startTimer() {
    _timer = new Timer(const Duration(seconds: 10), () {
      setState(() {
        _isHideBottomView = true;
      });
    });
  }

  void scrollToBottom() {
    final bottomOffset = (Platform.isIOS)
        ? _scrollController.position.maxScrollExtent
        : _scrollController.position.maxScrollExtent + 200;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _setMessageWidget() {
    return Container(
        color: Colors.grey[400].withOpacity(0.5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    backgroundColor: AppColor.red,
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColor.white),
                      onPressed: () {
                        if (_isMsgBtn) {
                          this._isreadMsg = 0;
                        }
                        setState(() {
                          this._isMsgBtn = !this._isMsgBtn;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    // color: AppColor.amber,
                    child: new ListView.builder(
                      controller: _scrollController,
                      itemCount: this.messageList.length,
                      itemBuilder: (context, index) {
                        return (this.messageList[index].type == '1')
                            ? _setLeftBubble(
                                '${this.messageList[index].message}',
                                '',
                                '0',
                                '')
                            : _setRightBubble(
                                '${this.messageList[index].message}',
                                '',
                                '0',
                                '');
                      },
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding:
                  new EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
              color: Colors.black38,
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.message,
                    color: AppColor.white,
                    size: 22,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  new Expanded(
                    child: new Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: AppColor.white),
                          borderRadius: BorderRadius.circular(5)),
                      padding: new EdgeInsets.only(left: 12, right: 12),
                      child: new TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) {
                          print('user is typing.......');
                        },
                        decoration: InputDecoration(
                            hintText: "Type Here...",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: AppColor.white, fontSize: 16)),
                        controller: _messageController,
                        style: TextStyle(color: AppColor.white, fontSize: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 22,
                    ),
                    color: AppColor.white,
                    onPressed: () {
                      if (this._messageController.text != "") {
                        Message msg =
                            Message('${this._messageController.text}', '0');
                        this.messageList.add(msg);
                      }

                      print('Message list count:${this.messageList.length}');
                      setState(() {});
                      this.scrollToBottom();
                      if (this._messageController.text != "") {
                        _signaling.sendMessage(this._messageController.text);
                        this._messageController.text = "";
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _setWaitingWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.black38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: AppColor.red,
          ),
          SizedBox(height: 15),
          setCommonText('Please wait...', AppColor.white, 14.0, FontWeight.w500,
              1, TextAlign.start),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              height: 50,
              width: 170,
              decoration: BoxDecoration(
                  color: AppColor.red, borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                onTap: () {
                  disposeMethod();
                  if (_signaling != null) _signaling.close();
                  _localRenderer.dispose();
                  _remoteRenderer.dispose();
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.call_end, color: AppColor.white),
                    SizedBox(width: 8),
                    setCommonText('Hangup Call', AppColor.white, 16.0,
                        FontWeight.w600, 1, TextAlign.start)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _setCallIconsWidget() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      // color: AppColor.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //MARK: mute/unmute speaker
          InkWell(
            onTap: () {
              _muteMic();
              //this should be come with provider
              setState(() {});
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.themeColor.withOpacity(0.7),
              child: Center(
                child: Icon(_isMute ? Icons.volume_up : Icons.volume_off,
                    color: AppColor.white),
              ),
            ),
          ),
          //MARK: Speaker Mode
          InkWell(
            onTap: () {
              if (_isSpeakerMode) {
                _signaling.speakerMode(false);
                _isSpeakerMode = false;
              } else {
                _signaling.speakerMode(true);
                _isSpeakerMode = true;
              }
              setState(() {});
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.themeColor.withOpacity(0.7),
              child: Center(
                child: _isSpeakerMode
                    ? Icon(Icons.speaker_phone)
                    : Icon(Icons.smartphone, color: AppColor.white),
              ),
            ),
          ),
          //MARK: Call End
          InkWell(
            onTap: () {
              if (_signaling != null) _signaling.close();
              _localRenderer.dispose();
              _remoteRenderer.dispose();
              _hangUp();
              disposeMethod();
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColor.red.withOpacity(0.9),
              child: Center(
                child: Icon(Icons.call_end, color: AppColor.white),
              ),
            ),
          ),
          //MARK: Switch Camera
          InkWell(
            onTap: () {
              _switchCamera();
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.themeColor.withOpacity(0.7),
              child: Center(
                child: Icon(Icons.flip_camera_ios, color: AppColor.white),
              ),
            ),
          ),
          //MARK: mute/unmute video
          InkWell(
            onTap: () {
              _hideVideo();
              setState(() {});
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.themeColor.withOpacity(0.7),
              child: Center(
                child: Icon(_isHideVideo ? Icons.videocam : Icons.videocam_off,
                    color: AppColor.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _inCalling
            ? OrientationBuilder(builder: (context, orientation) {
                return new Container(
                  child: new Stack(children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isHideBottomView = false;
                          _startTimer();
                        });
                      },
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: new RTCVideoView(
                          _remoteRenderer,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                        decoration: new BoxDecoration(color: AppColor.black38),
                      ),
                    ),
                    new Positioned(
                      left: 20.0,
                      top: 20.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          new Container(
                            width: orientation == Orientation.portrait
                                ? 90.0
                                : 120.0,
                            height: orientation == Orientation.portrait
                                ? 120.0
                                : 90.0,
                            child: new RTCVideoView(_localRenderer),
                            decoration:
                                new BoxDecoration(color: Colors.black54),
                          ),
                          this._isHideVideo
                              ? Icon(Icons.videocam_off, color: AppColor.white)
                              : Text('')
                        ],
                      ),
                    ),
                    new Positioned(
                      top: 10,
                      right: 15,
                      child: IconButton(
                        icon: Stack(
                          children: [
                            Icon(Icons.message, color: AppColor.white),
                            (_isreadMsg == 0)
                                ? Text('')
                                : Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                  )
                          ],
                        ),
                        onPressed: () {
                          // this.scrollToBottom();
                          setState(() {
                            this._isMsgBtn = !this._isMsgBtn;
                          });
                          // _showMessageAlertWindow();
                        },
                      ),
                    ),
                    new Positioned(
                      left: 0,
                      bottom: 0,
                      child:
                          _isHideBottomView ? Text('') : _setCallIconsWidget(),
                    ),
                    (_isMsgBtn) ? _setMessageWidget() : Text('')
                  ]),
                );
              })
            : _setWaitingWidget(),
      ),
    );
  }
}

_setLeftBubble(String message, String time, String type, String image) {
  return new Container(
    // height: 100,
    // padding: new EdgeInsets.only(left: 15, right: 100, top: 15, bottom: 15),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Bubble(
        margin: BubbleEdges.only(top: 10),
        alignment: Alignment.topLeft,
        nipWidth: 8,
        nipHeight: 24,
        nip: BubbleNip.leftTop,
        color: Color.fromRGBO(225, 255, 199, 1.0),
        child: Text('$message', textAlign: TextAlign.right),
      ),
    ),
  );
}

_setRightBubble(String message, String time, String type, String image) {
  return new Container(
    // height: 100,
    // padding: new EdgeInsets.only(left: 15, right: 100, top: 15, bottom: 15),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Bubble(
        margin: BubbleEdges.only(top: 10),
        alignment: Alignment.topRight,
        nipWidth: 8,
        nipHeight: 24,
        nip: BubbleNip.rightTop,
        color: AppColor.themeColor,
        child: Text(
          '$message',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColor.white),
        ),
      ),
    ),
  );
}

class Message {
  String message;
  String type;

  Message(this.message, this.type);
}
