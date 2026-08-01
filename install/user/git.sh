# Set identification from install inputs
if [[ -n ${OMANIRI_USER_NAME//[[:space:]]/} ]]; then
  git config --global user.name "$OMANIRI_USER_NAME"
fi

if [[ -n ${OMANIRI_USER_EMAIL//[[:space:]]/} ]]; then
  git config --global user.email "$OMANIRI_USER_EMAIL"
fi
