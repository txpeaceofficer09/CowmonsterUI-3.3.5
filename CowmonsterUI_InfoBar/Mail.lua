function InfoBarMail_OnEvent(self, event, ...)
	if ( HasNewMail() ) then
		InfoBarSetText("InfoBarMail", "Mail: %s", "New")
	else
		InfoBarSetText("InfoBarMail", "Mail: %s", "None")
	end
end
