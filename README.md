Personal IVR
============

A Personal Interactive Voice Response (IVR) System

###Introduction

This goal of this project is to develop a personal Interactive Voice Response (IVR) system using [Twilio](https://www.twilio.com/) and [BaseX](http://basex.org/). Since the [Twilio API](https://www.twilio.com/docs/api) uses [TwiML](https://www.twilio.com/docs/api/twiml) to communicate with applications, it seemed natural to build a system with XQuery and a native XML database.

###Configuration

The application requires two XML configuration files. These should be placed in a folder titled "Twilio". 

The first file ("auth.xml") contains your Twilio username, password, and phone number.

```
<auth xmlns="http://twilio/auth">
    <userName>##################</userName>
    <password>##################</password>
    <phoneNumber>##########</phoneNumber>
</auth>
```

The second file ("ids.xml") contain the contact information for members of your IVR.

```
<ids xmlns="http://twilio/contacts">
    <phone number="+1##########" option="1">
        <name>####</name>
    </phone>
    <phone number="+1##########" option="2">
        <name>####</name>
    </phone>
    <phone number="+1##########" option="3">
        <name>####</name>
    </phone>
    <phone number="+1##########" option="4">
        <name>####</name>
    </phone>
</ids>
```

