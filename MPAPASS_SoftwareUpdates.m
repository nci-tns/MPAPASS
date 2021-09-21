function [app]=MPAPASS_SoftwareUpdates(app)

d = uiprogressdlg(app.MPAPASS,'Title','Checking for updates',...
    'Indeterminate','on');
try
url = 'https://nano.ccr.cancer.gov/mpapass';
text = webread(url);
ind =  strfind(text,'v1.');

for i = 1:numel(ind)
    versions(i) = str2double(text(ind(i)+1:ind(i)+4));
end

close(d)
if app.version < max(versions)
    selection = uiconfirm(app.MPAPASS,'There is a new version of MPAPASS. Would you like to download now?','Software update','options',{'Ok','Later'},...
        'Icon','warning');
    switch selection
        case 'Ok'
            url = 'https://nano.ccr.cancer.gov/mpapass/';
            web(url, '-browser')
        otherwise
    end
else
    uialert(app.MPAPASS,'Your software is the current version','Software update','Icon','success');
end
catch
        uialert(app.MPAPASS,'Unable to connect to website to check for software updates','Software update','Icon','warning');

end
end