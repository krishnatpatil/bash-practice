MODULE=SOURCES/scripts
TEST_DIR_BASE=SOURCES/tests
TEST_DIR_RELATIVE=./$TEST_DIR_BASE
TEST_CASES=$TEST_DIR_RELATIVE/test_*
COV_REPORT=results/coverage.xml
UNIT_REPORT=results/test-results.xml
TEST_CONFIG=TestServiceConfig.txt

help(){
    echo "Usage: $0 [OPTION]..."
    echo "  -h, --help         Show this help output"
    echo "  -p, --pep8         Run pep8 checks"
    echo "  -l, --lint         Run pylint checks and some extra custom style checks"
    echo "  -u, --unit         Run unit tests"
    echo "  -pl, --pl          Run pep8 and pylint checks"
    echo "  --no-coverage      Don't make a unit test coverage report"
    echo ""
    exit 0;
}

fail(){
    echo "FAILURE"
    echo -e "$1"
    exit 1;
}

run_python_tests(){
    if [ -d results ]; then
        rm -rf results
    fi

    mkdir results

    if [ -f $TEST_CONFIG ]; then
        sed -i 's/:/ =/' $TEST_CONFIG
        sed -i '1s/^/[DEFAULT_SETTINGS]\n/' $TEST_CONFIG
    fi

    pytest -vv --cov=. --cov-report term-missing --junit-xml=$UNIT_REPORT --cov-report xml:$COV_REPORT $TEST_DIR_BASE
    TEST_RESULT=$?

    if [ $TEST_RESULT -gt 0 ]; then
        exit $TEST_RESULT;
    fi
}

run_unit_tests(){
    echo "************** Running unit tests *********************************"
    run_python_tests "unit"
}

run_pep8_check(){
    echo "************** Running pep8 checks ********************************"
    pycodestyle $MODULE --max-line-length=120
    echo "SUCCESS"
}

run_lint_check(){
    echo "************** Running pylint checks ******************************"
    pylint $MODULE --rcfile=".pylintrc"
    echo "SUCCESS"
}

# Determine script behavior based on passed options
# default behavior
just_pep8=0
just_lint=0
just_unit=0
testargs=""
include_coverage=1
all_style_checks=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help) shift; help;;
        -p|--pep8) shift; just_pep8=1;;
        -l|--lint) shift; just_lint=1;;
        -u|--unit) shift; just_unit=1;;
        -pl|--pl) shift; all_style_checks=1;;
        *) testargs="$testargs $1"; shift;
    esac
done

if [ $just_unit -eq 1 ]; then
    run_unit_tests
    exit $?
fi

if [ $just_pep8 -eq 1 ]; then
    run_pep8_check
    exit $?
fi

if [ $just_lint -eq 1 ]; then
    run_lint_check
    exit $?
fi

if [ $all_style_checks -eq 1 ]; then
    run_pep8_check
    run_lint_check
    exit $?
fi

run_unit_tests || exit
