Personal IVR
============

A Personal Interactive Voice Response (IVR) System

### Introduction

This goal of this project is to develop a personal Interactive Voice Response (IVR) system using [Twilio](https://www.twilio.com/) and [BaseX](http://basex.org/). Since the [Twilio API](https://www.twilio.com/docs/api) uses [TwiML](https://www.twilio.com/docs/api/twiml) to communicate with applications, it seemed natural to build a system with XQuery and a native XML database.

The application uses [RESTXQ](http://exquery.github.io/exquery/exquery-restxq-specification/restxq-1.0-specification.html) to handle incoming requests. Responses are all valid [TwiML](https://www.twilio.com/docs/api/twiml). 

### Functionality 

Currently, the system authenticates users by their phone number. Obviously, this presents a problem if you call in from a different number. Once authenticated, users can select from the list of contacts and then opt either to call them or to send them a text message. A third option–to leave a message–is not yet implemented.

### Configuration

The application requires two XML configuration files. These files should be placed in a BaseX database called "Twilio". 

The first file ("auth.xml") contains your Twilio username, password, and phone number.

```xml
<auth xmlns="http://cliffordanderson.info/modules/twilio/auth">
    <userName>##################</userName>
    <password>##################</password>
    <phoneNumber>##########</phoneNumber>
</auth>
```

The second file ("ids.xml") contains the contact information of members of your IVR.

```xml
<ids xmlns="http://cliffordanderson.info/modules/twilio/contacts">
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

