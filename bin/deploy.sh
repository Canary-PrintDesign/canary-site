echo "Travis branch: $TRAVIS_BRANCH"
echo "Building pull request? $TRAVIS_PULL_REQUEST"

if [[ $TRAVIS_BRANCH == production && !$TRAVIS_PULL_REQUEST ]] ; then
  export AWS_BUCKET='www.canaryprint.ca'
elif [[ $TRAVIS_BRANCH == master && !$TRAVIS_PULL_REQUEST ]] ; then
  export AWS_BUCKET='staging.canaryprint.ca'
else
  export AWS_BUCKET='dev.canaryprint.ca'
fi

echo "Deploying to $AWS_BUCKET"
bundle exec middleman sync
