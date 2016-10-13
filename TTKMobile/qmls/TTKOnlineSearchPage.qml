/* =================================================
 * This file is part of the TTK Music Player project
 * Copyright (c) 2014 - 2016 Greedysky Studio
 * All rights reserved!
 * Redistribution and use of the source code or any derivative
 * works are strictly forbiden.
   =================================================*/

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "Core"

Item {
    id: ttkOnlineSearchPage
    width: parent.width
    height: parent.height

    Connections {
        target: TTK_NETWORK
        onClearAllItems: {
            playlistModel.clear();
        }

        onCreateSearchedItems: {
            var info = {
                title: songname,
                artist: artistname
            };
            playlistModel.append(info);
        }

        onDownloadFinished: {
            TTK_APP.importNetworkMusicSongs(key, path);
        }
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        ///top bar
        Rectangle {
            id: mainMenubar
            Layout.fillWidth: true
            height: dpHeight(ttkTheme.topbar_height)
            color: ttkTheme.topbar_background

            RowLayout {
                id: mainMenubarLayout
                spacing: 2
                anchors.fill: parent

                TTKImageButton {
                    source: "qrc:/image/title_bar_back"
                    Layout.preferredWidth: dpWidth(50)
                    Layout.preferredHeight: dpHeight(50)
                    anchors.left: parent.left
                    onPressed: {
                        ttkMainStackView.pop();
                    }
                }

                TTKLineInput {
                    id: searchInput
                    Layout.preferredWidth: dpWidth(ttkMainWindow.width)
                    Layout.preferredHeight: dpHeight(33)
                    hint: "Big Bang"
                    fontSize: parent.height/3
                }

                TTKTextButton {
                    Layout.preferredWidth: dpWidth(50)
                    Layout.preferredHeight: dpHeight(50)
                    anchors.right: parent.right
                    textColor: ttkTheme.white
                    text: qsTr("搜索")

                    onPressed: {
                        TTK_NETWORK.searchSong(searchInput.text.length === 0 ? searchInput.hint
                                                                             : searchInput.text);
                    }
                }
            }
        }

        ///main body
        Rectangle {
            width: ttkMainWindow.width
            height: ttkMainStackView.height - mainMenubar.height
            color: ttkTheme.white

            ListView {
                id: searedSongList
                anchors.fill: parent
                clip: true

                delegate: Component {
                    Rectangle {
                        id: wrapper
                        width: ttkMainWindow.width
                        height: dpHeight(70)
                        color: ttkTheme.white

                        Rectangle {
                            width: ttkMainWindow.width
                            height: 1
                            color: ttkTheme.alphaLv9
                        }

                        Rectangle {
                            width: dpWidth(5)
                            height: parent.height*2/3
                            anchors {
                                top: parent.top
                                topMargin: parent.height/3/2
                            }
                            color: parent.ListView.isCurrentItem ? ttkTheme.topbar_background : ttkTheme.white
                        }

                        Text {
                            id: titleArea
                            text: title
                            width: ttkOnlineSearchPage.width - iconArea.width - dpHeight(120)
                            anchors {
                                top: parent.top
                                topMargin: dpHeight(10)
                                left: parent.left
                                leftMargin: dpHeight(20)
                            }
                            elide: Text.ElideRight
                            verticalAlignment: Qt.AlignVCenter
                            font.pixelSize: parent.height*3/10
                        }

                        Image {
                            id: iconArea
                            width: parent.height/3
                            height: parent.height/3
                            anchors {
                                top: titleArea.bottom
                                topMargin: dpHeight(5)
                                left: parent.left
                                leftMargin: dpHeight(20)
                            }
                            source: "qrc:/image/ic_playlist_normal"
                        }

                        TTKImageButton {
                            id: moreFuncArea
                            width: parent.height/2
                            height: parent.height/2
                            anchors {
                                top: parent.top
                                right: parent.right
                                topMargin: dpHeight(20)
                                rightMargin: dpHeight(20)
                            }
                            source: "qrc:/image/ic_playlist_more_normal"
                        }

                        TTKImageButton {
                            id: addFuncArea
                            width: parent.height/2
                            height: parent.height/2
                            anchors {
                                top: parent.top
                                right: moreFuncArea.left
                                topMargin: dpHeight(20)
                                rightMargin: dpHeight(5)
                            }
                            source: "qrc:/image/ic_playlist_add_normal"
                        }

                        Text {
                            id: artistArea
                            text: artist
                            width: titleArea.width - iconArea.width
                            anchors {
                                top: titleArea.bottom
                                topMargin: dpHeight(10)
                                left: iconArea.right
                                leftMargin: dpHeight(10)
                            }
                            elide: Text.ElideRight
                            verticalAlignment: Qt.AlignVCenter
                            font.pixelSize: parent.height/4
                            color: ttkTheme.gray
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                searedSongList.currentIndex = index;
                                TTK_NETWORK.setCurrentIndex(index);
                            }
                        }
                    }
                }

                model: ListModel {
                    id: playlistModel
                }

                Component.onCompleted: {
                    currentIndex = -1;
                }
            }
        }
    }
}
