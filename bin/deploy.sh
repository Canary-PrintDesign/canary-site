if [ $TRAVIS_BRANCH = production ] ; then
  export AWS_BUCKET='www.canaryprint.ca'
elif [ $TRAVIS_BRANCH = master ] ; then
  export AWS_BUCKET='staging.canaryprint.ca'
else
  export AWS_BUCKET='dev.canaryprint.ca'
fi

bundle exec middleman sync
