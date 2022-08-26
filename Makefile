install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt
	
test:
	python -m pytest -vv test_hello.py

lint:
		pylint --disable=R,C hello.py

all: install lint test

# env: 
# 	python3 -m venv myrepo && source myrepo/bin/activate

# install:
# 	pip install resolvelib && pip install --upgrade pip && pip install -r requirements.txt

# lint:
# 	pylint --disable=R,C,W0012,W1203,W0702,E0611,W0611,C0103,C0114,C0116,C0209 app.py

# test:
# 	python -m pytest -vv test_hello.py

# all:	install test lint


