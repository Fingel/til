TODAY=`date +%Y-%m-%d`

run:
	hugo server

new:
	hugo new post/${TODAY}-${TITLE}.md

s3sync:
	s3cmd sync images/ s3://artil/images/ -P

publish:
	git push origin master && git push github master
