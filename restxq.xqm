(:~
 : This module uses RESTXQ annotations to direct Twilio calls
 : @author Clifford Anderson
 :)

module namespace page = 'http://basex.org/modules/web-page';
import module namespace twilio = 'http://twilio' at 'twilio.xqy';

(:~
 : This function returns the result of a form request.
 : @param  $message  message to be included in the response
 : @param $agent  user agent string
 : @return response element 
 :)
declare
  %rest:path("/twilio/text/{$name}")
  %rest:POST
  %rest:form-param("TranscriptionText","{$message}", "No message!")
  function page:send-text(
    $message as xs:string?, $name as xs:string?)
{
    twilio:send-text($message, $name)
};


(:~
 : This function handles digits gathered by Twilio calls.
 : @param $number phone number string provided by Caller ID
 : @return Response element 
 :)
declare
  %rest:path("/twilio/pickup")
  %rest:query-param("From", "{$from}")
  %rest:GET
  function page:answer-call(
    $from as xs:string?)
    as element(Response)
{
     twilio:get-callerId($from)
};

(:~
 : This function answers Twilio calls.
 : @param $name string to be included in the welcome message
 : @return Response element 
 :)
declare
  %rest:path("/twilio/answer/{$name}")
  %rest:GET
  function page:answer-phone(
    $name as xs:string?)
    as element(Response)
{
    twilio:answer-phone($name)
};

(:~
 : This function handles digits gathered by Twilio calls.
 : @param $digits integer(s) provided by caller
 : @return Response element 
 :)
declare
  %rest:path("/twilio/gather")
  %rest:query-param("Digits", "{$digits}")
  %rest:GET
  function page:gather-digits(
    $digits as xs:string?)
    as element(Response)
{
    twilio:direct-outbound($digits)
};

(:~
 : This function handles call options gathered by Twilio calls.
 : @param $name string provided by caller
 : @param $digits integer(s) provided by caller
 : @return Response element 
 :)
declare
  %rest:path("/twilio/gather/{$name}")
  %rest:query-param("Digits", "{$digits}")
  %rest:GET
  function page:direct-choices(
    $digits as xs:string?, $name as xs:string?)
    as element(Response)
{
    twilio:direct-choices($digits, $name)
};

(:~
 : This function returns the result of a form request.
 : @param $RecordingUrl link to recorded message
 : @param $name name of mailbox owner string
 : @return response element 
 :)
declare
  %rest:path("/twilio/record/{$name}")
  %rest:query-param("RecordingURl", "{$url}")
  %rest:GET
  function page:record-url(
    $url as xs:string?, $name as xs:string?)
{
    <Response><Say>Goodbye {$name}</Say></Response>
    (: Add function to associate URL with appropriate mailbox :)
};

(:~
 : This function concludes Twilio calls.
 : @return Response element 
 :)
declare
  %rest:path("/twilio/goodbye")
  %rest:POST
  function page:goodbye()
    as element(Response)
{
  <Response>
    <Say>Goodbye! I hope you have a lovely day.</Say>
  </Response>
};
