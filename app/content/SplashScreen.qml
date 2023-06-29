/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Copyright 2022 NXP
** 
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
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
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
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
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

Window {
    id: splashWindow
    visible:true
    width: 640
    height: 480
    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - heigh / 2
    flags: Qt.SplashScreen | Qt.WindowStaysOnTopHint
    modality: Qt.ApplicationModal

    Rectangle{
        id:dot_1
        x:splashWindow.width*.3
        y:splashWindow.height/2-25
        width:40
        height:40
        color:"#808080"
        radius:100
        SequentialAnimation{
            running:true
            loops:Animation.Infinite
            ScaleAnimator {
                target:dot_1
                from:1
                to:0
                duration:840
            }
            ScaleAnimator{
                target:dot_1
                from:0
                to:1
                duration:840
            }
        }
    }
    Rectangle{
        id:dot_2
        x:splashWindow.width*.4
        y:splashWindow.height/2-25
        width:40
        height:40
        color:"#808080"
        radius:100
        SequentialAnimation{
            running:true
            PauseAnimation { duration: 120 }
            SequentialAnimation{
                loops:Animation.Infinite
                ScaleAnimator {
                    target:dot_2
                    from:1
                    to:0
                    duration:840
                }
                ScaleAnimator{
                    target:dot_2
                    from:0
                    to:1
                    duration:840
                }
            }
        }
    }
    Rectangle{
        id:dot_3
        x:splashWindow.width*.5
        y:splashWindow.height/2-25
        width:40
        height:40
        color:"#808080"
        radius:100
        SequentialAnimation{
            running:true
            PauseAnimation { duration: 240 }
            SequentialAnimation{
                loops:Animation.Infinite
                ScaleAnimator {
                    target:dot_3
                    from:1
                    to:0
                    duration:840
                }
                ScaleAnimator{
                    target:dot_3
                    from:0
                    to:1
                    duration:840
                }
            }
        }
    }
    Rectangle{
        id:dot_4
        x:splashWindow.width*.6
        y:splashWindow.height/2-25
        width:40
        height:40
        color:"#808080"
        radius:100
        SequentialAnimation{
            running:true
            PauseAnimation { duration: 360 }
            SequentialAnimation{
                loops:Animation.Infinite
                ScaleAnimator {
                    target:dot_4
                    from:1
                    to:0
                    duration:840
                }
                ScaleAnimator{
                    target:dot_4
                    from:0
                    to:1
                    duration:840
                }
            }
        }
    }

    Component.onCompleted: visible = true
}

