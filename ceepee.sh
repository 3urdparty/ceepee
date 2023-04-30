source ~/bin/ceepee/terminalformat.sh
source ~/bin/ceepee/proj_init.sh
source ~/bin/ceepee/lib_init.sh

docs_flag='false'
installable_flag='false'
libs=''
verbose_flag='false'

package="${bold}ceepee${NORMAL}"

print_help() {
    echo "$package - attempt to capture frames"
    echo " "
    echo "$package [options] application [arguments]"
    echo " "
    echo "options:"
    echo "init [lib][proj] NAME     initialize a Library/Project"
    echo "add [sublib] NAME         add Sublib to project"
    echo "-h, --help                show brief help"

    exit 0

}
print_usage() {
    printf "Usage: ..."
}

while test $# -gt 0; do
    case "$1" in
    -h | --help)
        print_help
        ;;
    init)
        shift
        if [ $# -gt 0 ]; then
            if [ $1 == "lib" ]; then
                shift
                if [ $# -gt 0 ]; then

                    LIB_NAME=$1

                    installable_flag='false'
                    docs_flag='false'
                    verbose_flag='false'
                    libs=''

                    while test $# -gt 0; do
                        shift
                        case "$1" in
                        -i) installable_flag='true' ;;
                        -d) docs_flag='true' ;;
                        -l)
                            shift
                            if test $# -gt 0; then
                                export OUTPUT=$2
                            else
                                echo "no libs specified"
                                exit 1
                            fi
                            echo "${OUTPUT}"
                            shift
                            ;;
                        -v) verbose_flag='verbose' ;;
                        *) ;;
                        esac
                    done

                    initializeLibrary $LIB_NAME $installable_flag $docs_flag $verbose_flag $libs
                else
                    printf "${RED}Error:${NC} Name of the library not provided. Please provide a name for you project.\n"
                fi
                exit 0
            elif [ $1 == "proj" ]; then
                shift
                if [ $# -gt 0 ]; then
                    LIB_NAME=$1

                    installable_flag='false'
                    docs_flag='false'
                    verbose_flag='false'
                    libs=''

                    while test $# -gt 0; do
                        shift
                        case "$1" in
                        -i) installable_flag='true' ;;
                        -d) docs_flag='true' ;;
                        -l)
                            shift
                            if test $# -gt 0; then
                                export OUTPUT=$2
                            else
                                echo "no libs specified"
                                exit 1
                            fi
                            echo "${OUTPUT}"
                            shift
                            ;;
                        -v) verbose_flag='verbose' ;;
                        *) ;;
                        esac
                    done
                    printf "Initializing ${bold}project${NORMAL} '${BLUE}$1${NC}'.\n"
                    initializeProject $LIB_NAME $installable_flag $docs_flag $verbose_flag $libs
                else
                    printf "${RED}Error:${NC} Name of the project not provided. Exiting.\n"
                fi

            fi

        else
            echo "no process specified"
            exit 1
        fi
        shift
        exit 0
        ;;
    add)
        shift
        if [ $# -gt 0 ] && [ $1 == "sublib" ]; then
            shift
            if [ $# -gt 0 ]; then
                printf "Initializing ${bold}sublibrary${NORMAL} '${BLUE}$1${NC}'.\n"

                # addLocalSublibrary $1
            else
                printf "${RED}Error:${NC} Name of the sublib not provided. Exiting.\n"
            fi
        else
            echo "Usage: add [sublib] SUBLIB_NAME"
        fi
        exit
        ;;
    --action*)
        export PROCESS=$(echo $1 | sed -e 's/^[^=]*=//g')
        shift
        ;;
    -v)
        shift
        echo "CeePee Version 1.0. 3urdparty at https://github.com/3urdparty"
        ;;

    *)
        echo "Command '$1' not recognized"
        break
        ;;
    esac
done

if [ $# == 0 ]; then
    print_help
fi
