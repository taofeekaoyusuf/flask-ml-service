# env: 
# 	python3 -m venv myrepo && source myrepo/bin/activate

install:
	pip install resolvelib && pip install --upgrade pip && pip install -r requirements.txt

lint:
	pylint --disable=R,C,W1203,W0702,E0611,W0611,C0103,C0114,C0116,C0209,127 hello.py

test:
	python -m pytest -vv test_hello.py


all:	install test lint

