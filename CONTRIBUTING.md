# Contributing Guidelines

These examples will show the guidelines for contributing. Please try to follow this at all times, or we may not merge your contribution.

## Basic Guidelines:
- Use Tabs to indent code, DO NOT USE SPACE.
- Use lowerCamelCase or underscores for naming Nasal variables/functions (someFunction, some_function).
- Use comments when necessary, but no need to comment simple things.
- Do not add a comment to every line, only to functions/groups of code.
- Remove .bak or .blend files, unless absolutely needed.
- Leave one extra line at the bottom of each file.
- DO NOT USE setprop/getprop unless its only done once! Use props.nas and Property Tree Setup.

## Formatting Guidelines:
Indenting and Line Breaks:
```
<!-- XML -->
<something>
	<something-else>0</something-else>
	<something-more>
		<more-stuff></more-stuff>
	</something-more>
</something>
```

```
# Nasal
var something = func() {
	somethingElse();
}
```
Brackets, Spaces, Commas, Semi-Colons, and Parentheses:
```
var something = 0;
var someOtherThing = func() {
	if (something == 1) {
		something = 0;
	} else {
		something = 1;
	}
	settimer(func {
		props.globals.getNode("/something").setValue(something);
	}, 5);
}
```

## Forks, Branches, and Merging
Please fork the repository on [GitHub](https://github.com/Octal450/MD-11) (not FGAddon) and commit your changes there. Branches are optional. When you are ready for us to look over your work, submit a pull request following our pull request template, and we will look over it. If there is an issue that needs to be resolved before merging, then we will leave a comment on the pull request.
