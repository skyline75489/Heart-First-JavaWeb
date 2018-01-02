#!/bin/sh
cd ..
mkdir heart-first-javaweb-gitbook
cd heart-first-javaweb-gitbook
git init
git remote add origin https://github.com/skyline75489/Heart-First-JavaWeb.git
git fetch
git checkout origin/gh-pages -b gh-pages
cd ../interview
cd source
gitbook install
cd ..

