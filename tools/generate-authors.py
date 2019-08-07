#!/usr/bin/env python3
# -*- coding: utf_8 -*-

"""
MIT License

Copyright (c) 2019 Pierre-Yves Lapersonne (Mail: dev@pylapersonne.info)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

"""
File................: generate-author.py
Author..............: Pierre-Yves Lapersonne
Version.............: 1.0.0
Since...............: 06/08/2019
Description.........: Extract contributors stored in a JSON file a produce a MarkDown file for the repository

Usage: python generate-authors.py --source ../project/NearbyWeather/DevelopmentContributors.json > AUTHORS.md
"""

import argparse
import sys
import json

if __name__ == "__main__":

	# Get parameters
	parser = argparse.ArgumentParser(description='Tool for NearbyWeather app to build AUTHORS.md file based on JSON source.')
	parser.add_argument('--source', dest='source', help='The path to the JSON file containing data to parsed')
	args = parser.parse_args()

	if not args.source:
		print "Usage: python generate-authors.py --source ../project/NearbyWeather/DevelopmentContributors.json > AUTHORS.md"
		sys.exit()

    # Read JSON source file
	with open(args.source) as json_source:
		data = json.load(json_source)

    	# Produce in standard output MarkDown file
    	print "# Authors \n"
    	for contributor in data["elements"]:
    		desc = contributor["contributionDescription"]
    		first_name = contributor["firstName"]
    		last_name = contributor["lastName"]
    		url = contributor["urlString"]
    		print "## %s \n" % desc
    		print "* %s %s - %s \n" % (first_name, last_name, url)
    	






