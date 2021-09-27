# Design
```text
UseCase
	name
	request (simplest form)
	response
	exceptions
	error handling
	request (configurable parts)

Controller
	input
	conversion: input2request
	output
	conversion: response2output
	conversion: exception2outcome
	conversion: conversion exceptions

Domain object
	name
	repository method signature
	repository method exceptions
	repository method error handling
	invariantExceptions

DependencyInversion
	Register: UseCase
	Register: converter
	Register: repository

Testing order:
First, 
	Domain Objects
Then, for each UseCase test scenario
	Controller - UseCase - Domain Object
Then
	Controller
```
