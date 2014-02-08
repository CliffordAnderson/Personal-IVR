xquery version "3.0";

module namespace twilio = "http://twilio";

declare namespace contacts = "http://twilio/contacts";
declare namespace auth = "http://twilio/auth";

declare variable $twilio:userName as xs:string := 
    fn:string(fn:doc("twilio/auth.xml")//auth:userName/text());
declare variable $twilio:password as xs:string := 
    fn:string(fn:doc("twilio/auth.xml")//auth:password/text());
declare variable $twilio:phoneNumber as xs:string := 
    fn:string(fn:doc("twilio/auth.xml")//auth:phoneNumber/text());
    
declare function twilio:get-callerId($from as xs:string?) {
    let $name := fn:doc("twilio/ids.xml")//contacts:phone[@number = $from]/contacts:name/text()
    return 
        if ($name) then twilio:answer-phone($name)
        else twilio:answer-phone("test")
};

declare function twilio:answer-phone($name as xs:string) {
    <Response>
    	<Say>Hello, {$name}.</Say> 
        {twilio:gather-call-list()}
    </Response>
};

declare function twilio:challenge() {
    <Response>
    	<Say>I'm sorry, but I don't recognize you.</Say> 
    </Response>
};

declare function twilio:gather-call-list() {
    <Gather action="/twilio/gather" method="GET" timeout="10">
        <Say>Please enter</Say>
        {for $person in fn:doc("twilio/ids.xml")//contacts:phone
         return <Say>{$person/@option/data()} for {$person/contacts:name/text()}</Say>}
        <Say>or please press * to hear these options again.</Say>
    </Gather>
};

declare function twilio:direct-choices($digits as xs:string?, $name as xs:string?) as element(Response) {
    let $number := fn:string(fn:doc("twilio/ids.xml")//contacts:phone[./contacts:name = $name]/@number)
    let $option := fn:data(fn:doc("twilio/ids.xml")//contacts:phone[./contacts:name = $name]/@option)
    return
        switch ($digits)
        case "1" return 
            <Response>
                <Say>Calling {$name}</Say>
                {twilio:make-call($number)}
            </Response>
        case "2" return
            <Response>
                <Say>Please say your text message for {$name} after the tone.</Say>
                 {twilio:transcribe-message($name)}
            </Response>
        case "3" return
            <Response>
                <Say>Please leave your message for {$name} after the tone.</Say>
                <Record timeout="30" transcribe="false" method="GET" action="/twilio/record/{$name}"/>
            </Response>
        case "*" return
            <Response>
                {twilio:gather-call-list()}
            </Response>
        default return 
            <Response>
                <Say>You entered {$digits}, but that's not an option.</Say>
                <Redirect method="GET">/twilio/gather?Digits={$option}</Redirect>
            </Response>
};

declare function twilio:transcribe-message($name as xs:string) as element(Record) {
    <Record transcribe="true" transcribeCallback="/twilio/text/{$name}" action="/twilio/goodbye" method="POST" />
};

declare function twilio:send-text($message as xs:string?, $name as xs:string?) {
    let $number := fn:string(fn:doc("twilio/ids.xml")//contacts:phone[./contacts:name = $name]/@number)
    let $request :=
        <http:request href="{'https://api.twilio.com/2010-04-01/Accounts/' || $twilio:userName || '/SMS/Messages.xml'}"
        method='post' username='{$twilio:userName}' password='{$twilio:password}' send-authorization='true' auth-method='basic'>
        <http:body media-type="application/x-www-form-urlencoded" method="text">Body={$message}&amp;To={$number}&amp;From={$twilio:phoneNumber}</http:body>
        </http:request>
    return (<Response/>, http:send-request($request)) 
};

declare function twilio:make-call($phone-number) {
    <Dial timeout="20" record="false">{$phone-number}</Dial>
};

declare function twilio:direct-outbound($digits as xs:string?) as element(Response) {
    if ($digits = "*") then 
        <Response>{twilio:gather-call-list()}</Response>
    else
        let $name := fn:doc("twilio/ids.xml")//contacts:phone[@option = $digits]/contacts:name/text()
        return
        <Response>
            <Gather action="/twilio/gather/{$name}" method="GET" timeout="10">
                <Say>Press 1 to call {$name}, press 2 to text {$name}, press 3 to leave a message for {$name}, or press * to return to the main menu.</Say>
            </Gather>
        </Response>
};
