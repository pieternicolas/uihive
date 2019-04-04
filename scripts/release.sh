# # Get version argument from package.json
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

# Start
echo "Releasing version $PACKAGE_VERSION"
echo "-------------------------------------------------------------------------"

# Ensure working directory in version branch clean
git update-index -q --refresh
if ! git diff-index --quiet HEAD --; then
  echo "Working directory not clean, please commit your changes first"
  exit
fi

# Checkout master branch and merge staging branch into master
git checkout master
git merge staging --no-ff --no-edit

# Build files using webpack
yarn build

# Run version script, creating a version tag, and push commit and tags to remote
npm version $PACKAGE_VERSION
git add .
git commit -m "Release $PACKAGE_VERSION"
git push
git push --tags

# Success
echo "-------------------------------------------------------------------------"
echo "Release $PACKAGE_VERSION complete"

# Go back to develop branch
git checkout develop