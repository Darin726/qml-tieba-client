/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root
    property string mode: "normal" // Read-only
    property alias paddingItem: paddingItem // Read-only

    property bool enabled: true
    property bool subItemIndicator: false
    property bool platformInverted: false

    signal clicked
    signal pressAndHold

    implicitWidth: ListView.view ? ListView.view.width : screen.width
    implicitHeight: platformStyle.graphicSizeLarge

    Rectangle {
        height: 1
        color: root.platformInverted ? platformStyle.colorDisabledLightInverted
                                     : platformStyle.colorDisabledMid
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        onPressed: {
            symbian.listInteractionMode = Symbian.TouchInteraction
            internal.state = "Pressed"
        }
        onClicked: {
            internal.state = ""
            root.clicked()
        }
        onCanceled: {
            internal.state = "Canceled"
        }
        onPressAndHold: {
            internal.state = "PressAndHold"
        }
        onReleased: {
            internal.state = ""
        }
        onExited: {
            internal.state = ""
        }
    }
    Keys.onReleased: {
        if (!event.isAutoRepeat && root.enabled) {
            if (event.key == Qt.Key_Select || event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                event.accepted = true
                internal.state = "Focused"
            }
        }
    }

    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
                case Qt.Key_Select:
                case Qt.Key_Enter:
                case Qt.Key_Return: {
                    if (symbian.listInteractionMode != Symbian.KeyNavigation)
                        symbian.listInteractionMode = Symbian.KeyNavigation
                    else
                        if (root.enabled) {
                            root.clicked()
                        }
                    event.accepted = true
                    break
                }

                case Qt.Key_Up: {
                    if (symbian.listInteractionMode != Symbian.KeyNavigation) {
                        symbian.listInteractionMode = Symbian.KeyNavigation
                        internal.state = "Focused"
                        ListView.view.positionViewAtIndex(index, ListView.Beginning)
                    } else
                        ListView.view.decrementCurrentIndex()
                    event.accepted = true
                    break
                }

                case Qt.Key_Down: {
                    if (symbian.listInteractionMode != Symbian.KeyNavigation) {
                        symbian.listInteractionMode = Symbian.KeyNavigation
                        ListView.view.positionViewAtIndex(index, ListView.Beginning)
                        internal.state = "Focused"
                    } else
                        ListView.view.incrementCurrentIndex()
                    event.accepted = true
                    break
                }
                default: {
                    event.accepted = false
                    break
                }
            }
        }

        if (event.key == Qt.Key_Up || event.key == Qt.Key_Down)
            symbian.privateListItemKeyNavigation(ListView.view)
    }

    Item {
        // non-visible item to create a padding boundary that content items can bind to
        id: paddingItem
        anchors {
            left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom
            leftMargin: platformStyle.paddingLarge
            rightMargin: privateStyle.scrollBarThickness
            topMargin: platformStyle.paddingLarge
            bottomMargin: platformStyle.paddingLarge
        }
    }

    StateGroup {
        id: internal

        function getMode() {
            if (internal.state == "Pressed" || internal.state == "PressAndHold")
                return "pressed"
            else if (internal.state == "Focused")
                return "highlighted"
            else if (internal.state == "Disabled")
                return "disabled"
            else
                return "normal"
        }

        // Performance optimization:
        // Use value assignment when property changes instead of binding to js function
        onStateChanged: { root.mode = internal.getMode() }

        function press() {
            privateStyle.play(Symbian.BasicItem)
        }

        function release() {
            if (symbian.listInteractionMode != Symbian.KeyNavigation)
                privateStyle.play(Symbian.BasicItem)
        }

        function releaseHold() {
        }

        function hold() {
            root.pressAndHold()
        }

        function disable() {
        }

        function focus() {
        }

        function canceled() {
        }

        states: [
            State { name: "Pressed" },
            State { name: "PressAndHold" },
            State { name: "Disabled"; when: !root.enabled },
            State { name: "Focused"; when: (root.ListView.isCurrentItem &&
                symbian.listInteractionMode == Symbian.KeyNavigation) },
            State { name: "Canceled" },
            State { name: "" }
        ]

        transitions: [
            Transition {
                to: "Pressed"
                ScriptAction { script: internal.press() }
            },
            Transition {
                from: "Pressed"
                to: "PressAndHold"
                ScriptAction { script: internal.hold() }
            },
            Transition {
                from: "PressAndHold"
                to: ""
                ScriptAction { script: internal.releaseHold() }
            },
            Transition {
                to: ""
                ScriptAction { script: internal.release() }
            },
            Transition {
                to: "Disabled"
                ScriptAction { script: internal.disable() }
            },
            Transition {
                to: "Focused"
                ScriptAction { script: internal.focus() }
            },
            Transition {
                to: "Canceled"
                ScriptAction { script: internal.canceled() }
            }
        ]
    }
}
