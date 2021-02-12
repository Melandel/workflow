# GRPC
* Comme wcf mais multi langage
* au début, création d'un .proto
* derrière, vs le compile en C#/C++
* C'est du protobuf dans le moyen de communication
	* protobuf est comme json, mais en binaire, c'est un format de serialisation fait par google
* En plus de protobuf, google a implémenté des fonctions d'appels en remote (rpc) + streaming
* grpc est une API de communication, basé sur un format de serialisation nommé protobuf
* Ne supporte pas les null, ne supporte pas l'héritage, à la place il y a de la composition ("OneOf")
* Supporte le streaming (utilisé dans la communication avec le storage service pour être notifié des changementsf)
* etcd utilise grpc nativement
	* grpc utilisé entre StorageService & ETCD
	* grpc utilisé entre StorageService & Cortex
	* grpc utilisé entre Cortex & l'API
	* grpc utilisé entre l'API & StorageService (pour vérifier le mdp exclusivement, pour le moment_tm)
* when creating enums through a proto file, always create the first element as UNKNOWN_NAME_OF_THE_ENUM
* Because grpc is duuuuuuuuuuumb (but less than wpf that explodes)
* HubCensusServiceBase: classe générée
* GrpcHubCensusService: class à nous
* Les services grpc sont de la plomberie (moulinette)
