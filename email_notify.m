%sendemail
function email_notify(sendtoaddress,title,content,attach)
%%2012-4-9 by zifang zhao 修正无attach时不能发送的问题
myaddress = 'nri_matlab@sina.com';
mypassword = 'wan1151';

setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.sina.com');
setpref('Internet','SMTP_Username','nri_matlab');
setpref('Internet','SMTP_Password',mypassword);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
try
    if nargin<4
        sendmail(sendtoaddress,title,content,attach);
    else
        sendmail(sendtoaddress,title,content);
    end
catch err
    err
end