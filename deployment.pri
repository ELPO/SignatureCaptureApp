# Common methods for deployment

# Dependencies
# Function to copy specified files to build directory
defineTest(copyToBuildDir) {
    files = $$1
    DDIR = $${DESTDIR}

    for(FILE, files) {
        win32:FILE ~= s,/,\\,g
        win32:DDIR ~= s,/,\\,g

        QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$FILE) $$quote($$DDIR) $$escape_expand(\\n\\t)
    }

    export(QMAKE_POST_LINK)
}

# Function to deploy Qt dependencies, taking 2 arguments: QML directory and target file as variables
defineTest(deployQtDependencies) {
    qml_dir = $$1
    target_file = $$2

    QMAKE_POST_LINK += $${DEPLOY_COMMAND} --qmldir $${qml_dir} $${target_file} $$escape_expand(\n\t)

    export(QMAKE_POST_LINK)
}

# Function to call CMake and copy the DLLs from the binary path
defineTest(deployDLLDependencies) {
    target_file = $$1
    binary_path = $$2

    QMAKE_POST_LINK +=  cmake -DTARGET_FILE=\"$${target_file}\" -DBINARY_PATH=\"$${binary_path}\" -P $$PWD/../../deploy_dlls.cmake $$escape_expand(\n\t)

export(QMAKE_POST_LINK)
}
