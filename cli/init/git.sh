git init
git add .
git commit -m "Initial Commit"
git push

git submodule add https://github.com/ImkeF/M.git Repos/ImkeF/M
git submodule add https://github.com/Hugoberry/PowerQueryExtensions.git Repos/Hugoberry/PowerQueryExtensions
git submodule add https://github.com/Hugoberry/PowerQueryFunctional.git Repos/Hugoberry/PowerQueryFunctional
git submodule add https://github.com/acaprojects/m-tools.git Repos/acaprojects/m-tools
git submodule add https://github.com/tirnovar/m-custom-functions.git Repos/tirnovar/m-custom-functions
git submodule add https://github.com/getkks/Power-Query.git Repos/getkks/Power-Query
git submodule add https://github.com/mogulargmbh/powerquerysnippets.git Repos/mogulargmbh/powerquerysnippets
git submodule add https://github.com/JaySumners/Power-BI-Tools.git Repos/JaySumners/Power-BI-Tools
git submodule add https://github.com/hohlick/pquery.git Repos/hohlick/pquery
git submodule add https://github.com/camwally/Power-Query.git Repos/camwally/Power-Query
git add --all
git commit -am "Add submodules"
git push