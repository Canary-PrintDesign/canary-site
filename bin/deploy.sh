echo $TRAVIS_BRANCH
echo $TRAVIS_PULL_REQUEST
branch_name="$(git symbolic-ref --short -q HEAD)"
echo $branch_name
if [[ $TRAVIS_BRANCH = production && !$TRAVIS_PULL_REQUEST ]] ; then
  echo 'dep www'
  export AWS_BUCKET='www.canaryprint.ca'
elif [[ $TRAVIS_BRANCH = master && !$TRAVIS_PULL_REQUEST ]] ; then
  echo 'dep staging'
  export AWS_BUCKET='staging.canaryprint.ca'
else
  echo 'dep dev'
  export AWS_BUCKET='dev.canaryprint.ca'
fi

bundle exec middleman sync
