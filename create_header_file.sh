createHeaderFile() {
    local upper=$(tr '[a-z]' '[A-Z]' <<<$1)
    echo "#ifndef ${upper}_HPP
#define ${upper}_HPP


#endif"
}