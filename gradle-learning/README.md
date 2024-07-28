# Gradle Learning Notes

### What is Gradle?

    Gradle is a build tool. It will run your project builds and tests, it will also generate test reports for you
    based on the build output.

### Languages

    Gradle uses two languages: Groovy and Kotlin.

### Where do the artifacts go when I build a Gradle project?

    $projectDir\build\libs

### Gradle Wrapper

    gradlew build

        Will build your gradle project using the embedded gradle tool [gradlew(linux,macOS)|gradlew.bat(windows)].

### settings.gradle

    This file contains the config for your Gradle project, it includes things like root project name and
    any projects that you might want to include in a multi-project project.

    Note: Each sub-project will have its own Gradle config (build.gradle).

### ***[command]*** gradlew clean

    This command removes build directory.

### ***[commad]*** gradlew test

    This command runs through your subfiles, builds them and runs their tests. The output is a test report.

    Test can be found at: $projectDir\build\reports\tests\test\index.html

    Note: Re-running tests/builds may run a cached version if no changes made.

### ***[command flag]*** gradlew test -p $sub-project

    This command will run the specified sub-projects test. Report can be found a location noted in gradlew test.

### build.gradle | build.gradle.kts [kotlin]

    Note: The above standard is not the latest way of doing things. [RESEARCH]
    
    Project details:

        group = '$com.your.company'
        version = '$yourVersion'
        sourceCompatibility = '$javaVersion'

    Plugin scopes:
        The plugins block is defined like:

            plugins {
                id ...
            }
    
        id '$plugin' version '$version'

    Dependency scopes:
        The depencies block is defined like:

            dependencies {
                implementation ...
                implementation project() ...
                testImplementation ...
                api ...
            }

        implementation: '$someDependency' - This will import a dependecy into the project.
        implementation project(':$yourProject') - This will reference your project into your current project.

            Note: The scope of the imported projects dependencies are not inherited by the importing project.
                  You can change this by using the api scope instead of implementation, however you'll need to 
                  add the api plugin. It isn't usually recommended to do this and would be cleaner to just
                  import that dependency into your gradle project.

        testImplementation: '$someDependency' - This will import a dependency for your test cases, not the final
        artifact.

        Note: older versions of gradle may use compile/testCompile instead of implementation/testImplementation

