Title: Setting Up A Home Phone and Dial-up Network
Tags: phones,dialup,vintage computers
Published: 15/02/2024
Disabled: 1

---
# Setting Up A Home Phone and Dial-up Network

I have quite a few vintage computers, and most of them have modems. At this point in time, there are two groups of people I know - those who don't know what modems are, and those who used them and never want to revisit them.

Whilst I have never needed to really use a modem (and I'm grateful for that), they do intrigue me - transmitting data over phone cables was a brilliant idea for the time.

I decided that I wanted to try to create my own, internal dialup system for my house, so I could experience the blistering-fast 28.8k speeds for myself.

I read many guides online, but many of them centered on basically directly connecting two devices. Whilst this would work, it wasn't quite interesting or difficult enough, so I decided to setup an entire (virtual) PBX system using Asterisk.

## Parts

The most important part was the analogue to digital gateway - I used a Cisco SPA-122:

![SPA-122](images/dialup/2023-12-14-10-19-50-661.jpg-50p.jpg)

The next part was the modem for the server, and the server itself.
For the server I used a Raspberry Pi 4, and for the modem I found a used Hayes modem, and purchased a serial to USB adapter.

![Raspberry Pi](images/dialup/2023-12-14-10-22-03-815.jpg-50p.jpg)
![Modem](images/dialup/2023-12-14-10-21-33-200.jpg-50p.jpg)

I also needed a switch, so used this gigabit switch from Netgear.

![Switch](images/dialup/2023-12-14-10-20-26-374.jpg-50p.jpg)

## Setting up the PBX

I installed asterisk via Docker as defined here: [https://github.com/radams15/asterisk-docker](https://github.com/radams15/asterisk-docker).

I added an extension `101` for the server and `102` for the client in ./conf/etc/asterisk/pjsip.conf:

    [101](sip-endpoint)
    auth=auth101
    aors=101

    [auth101](sip-auth)
    password=101
    username=101

    [101](sip-aor)


    [102](sip-endpoint)
    auth=auth102
    aors=102

    [auth102](sip-auth)
    password=102
    username=102

    [102](sip-aor)

I then ran `docker-compose up -d` to start the container.

## Setting up the SPA-122

The config for this was fairly easy - just loading the settings from before into the web console:

![SPA-122 Config](images/dialup/spa122_conf.png)
