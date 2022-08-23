env: 
	python3 -m venv myrepo && source myrepo/bin/activate

install:
	pip install resolvelib==0.5.3 && pip install --upgrade pip && pip install -r requirements.txt

test:
	python -m pytest -vv test_hello.py


lint:
	pylint --disable=R,C,W1203,W0702,E0611,W0611,C0103,C0114,C0116,C0209,127 hello.py

all:	env install test lint

