#! /run/current-system/sw/bin/sh

unread="$(find "${HOME}"/mail/gmail/INBOX/new/ -type f | wc -l 2>/dev/null)"

if [ "$unread" == "0" ]; then
  echo ""
else
  echo "GMail: $unread"
fi

