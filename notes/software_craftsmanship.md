* Le texte qui suit est une combinaison d'informations vérifiables et d'éléments de mon interprétation personnelle (et pas forcément aussi mûrs que je l'aimerais).
* Le but n'est pas d'imposer ma vision, mais de partager où j'en suis personnellement sur le sujet.
* Il y a beaucoup de points que je n'ai pas creusés comme je le voudrais, et je prends tous les retours comme une opportunité de consolider mes connaissances dans le sujet alors n'ayez pas peur d'engager le débat avec moi :lotus: 

Pavé César, je te salue!

### Le CHAOS report de 1995

Petit cours d'histoire - on remonte en 1995, où le Standish Group publie un papier nommé `The CHAOS (Comprehensive Human Appraisal for Originating Software) Report` contenant l'analyse de plus de 8000 projets informatiques.

Le rapport considérait qu'un projet était:

* _réussi_ s'il répondait à toutes les exigences initialement spécifiées, à la fois dans les délais et dans le respect du budget (connu dans le jargon PM sous le nom de « triangle de fer »)
* _en difficulté_ s'il y avait eu dépassement du budget, dépassement du calendrier et/ou manque de fonctionnalités

Sur la base de ces critères, l'étude a révélé que:

* **16,2%** des projets observés étaient **_réussis_**
* 52,7% étaient _en difficulté_
* 31,1% des projets étaient _annulés_

> On the success side, the average is only 16.2% for software projects that are completed on-time and on-budget. In the larger companies, the news is even worse: only 9% of their projects come in on-time and on-budget. And, even when these projects are completed, many are no more than a mere shadow of their original specification requirements. Projects completed by the largest American companies have only approximately 42% of the originally-proposed features and functions. Smaller companies do much better. A total of 78.4% of their software projects will get deployed with at least 74.2% of their original features and functions.

([source](https://www.csus.edu/indiv/r/rengstorffj/obe152-spring02/articles/standishchaos.pdf))

### La méthode structurée majoritairement employée à l'époque : le cycle en V (modèle Waterfall/en cascade)

A cette époque, suite à un papier en 1970 de Winston W. Royce in 1970 `Managing the Development of Large Software Systems`, qui décrivait un modèle de développement logiciel en 6 étapes successives:

1. **Exigences** : les exigences font l'objet d'une expression des besoins ;
2. **Analyse** : les exigences sont analysées pour établir un **cahier des charges** fonctionnel ;
3. **Conception** : le produit est conçu et **spécifié** de sorte à pouvoir être réalisé ;
4. **Mise en œuvre** : le produit est **implémenté** sur la base des spécifications ;
5. **Validation** : le produit est **testé** et vérifié et sa conformité aux exigences est validée ;
6. **Mise en service** : le produit est **installé**, les préparatifs pour sa mise en service sont organisés, puis le produit est **utilisé**.

Il avait également reconnu que ce modèle était **risqué** et **risquait d'aboutir à l'échec**, et a suggéré quelques modifications pour l'améliorer, telles que le développement itératif et les boucles de rétroaction. Cependant, son article a été **largement interprété à tort comme une approbation du modèle séquentiel et rigide**. Etant très compatible avec la gestion de projet traditionnelle de l'époque orientée Process rigides (Project Management Body of Knowledge (PMBOK, 1996), Capability Maturity Model (CMM, 1986)), il a été utilisé partout et s'est imposé comme "la façon de gérer un projet informatique".

([source](https://www.linkedin.com/advice/3/how-did-waterfall-methodology-emerge))

### Les méthodes Light/Lightweight & Toyota

Dans les années 1990, des développeurs se sont tout de même dit que c'était pas très efficace, et des pionniers ont commencé à travailler des méthodes de travail différentes. On retrouvera par exemple:

* Scrum (1990) de Jeff Sutherland(["Estimating tasks will slow you down. Don't do it. We gave it up over 16 years ago."](https://www.quora.com/What-are-the-techniques-set-by-the-Scrum-guidelines-for-a-task-estimation-in-sprint-planning-Are-there-any-limitations-to-these-techniques)) & Ken Schwaber (["I estimate that 75% of those organizations using Scrum will not succeed in getting the benefits that they hope for from it."](https://www.azquotes.com/quote/1355298))
* Crystal d'Alistair Cockburn (inventeur de l'[architecture hexagonale](https://alistair.cockburn.us/hexagonal-architecture))
* Extreme Programming (XP) de Kent Beck (qui est à la source de 90% de nos bonnes pratiques)
* Feature Driven Development
* Adaptive Software Development
* Jean Passe.

Ces méthodes de travail ont toutes pour caractéristiques de proposer un nombre de règles moins rigides, plus simples, ou bien moins nombreuses.

Elles prennent leur inspiration dans le succès de Toyota au Japon, avec le TPS (Toyota Production System), dont les deux piliers sont:

* [l'autonomation, ou jidoka](https://fr.wikipedia.org/wiki/Jidoka) (Détecter les défauts au plus tôt & Éliminer la non-qualité à la source)
* [le juste-à-temps, ou lean manufacturing](https://fr.wikipedia.org/wiki/Juste-%C3%A0-temps_(gestion)) (Viser les 5 zéros: zéro panne, zéro délai, zéro papier, zéro stock et zéro défaut)

Je ne saurais que trop vous inviter à vous renseigner sur le sujet, je trouve ça personnellement passionnant.

Chez Toyota, n'importe quel ouvrier a(vait?) par exemple à sa disposition un dispositif pour interrompre l'entièreté de la production de la boite, car il revient plus cher de produire plusieurs voitures qui génèrent des accidents, que d'arrêter la production le temps d'enlever le défaut. On imaginerait mal ce niveau de distribution de responsabilité en France ou en Amérique!

### Le développement Agile de logiciels

A l'époque, les pionniers se voient souvent via des conférences. En 2001, Uncle Bob, un développeur très renommé, invite 17 pionniers liés de près aux méthodes Lightweight à un week-end de Ski dans les montagnes de l'Utah, dans la station Snowbird. Durant ce weekend, il tente pour le fun d'écrire un manifeste qui regrouperait des choses auxquelles 17 personnes seraient d'accord. De façon surprenante, un texte sur lequel 17 personnes tombent d'accord prend forme, très très rapidement:
> We are uncovering better ways of developing software by doing it and helping others do it. Through this work we have come to value:  
> * Individuals and interactions over processes and tools
> * Working software over comprehensive documentation
> * Customer collaboration over contract negotiation
> * Responding to change over following a plan
>  
>  That is, while there is value in the items on the right, we value the items on the left more.

Ce manifeste est signé par les 17 personnes, et l'un d'entre eux propose de trouver un mot plus sexy que `Light/Lightweight` pour en parler, parce que dire que être un partisan "lightweight" n'aide pas à être pris au sérieux. Les gens se mirent d'accord pour un meilleur mot : on parlera d'un développement de logiciels `agile`.

Ainsi naquit le [manifeste du développement Agile de logiciels](https://agilemanifesto.org/), et l'officialisation du mouvement de pensée du `développement Agile de logiciels.`

### Réception mondiale

Tout le monde a commencé à parler de ce manifeste, et en particulier, les gestionnaires de projet. Selon Dave Thomas (l'un des signataires), l'une des plus grosses erreurs des signataires a été de choisir le nom de domaine `agilemanifesto` et non `agilesoftwaredevelopment` ([source](https://www.youtube.com/watch?t=552&v=a-BOSpxYJ9M&feature=youtu.be)). Pourquoi c'était important? Parce qu'on a viré la notion que c'était `le développement de logiciel` qui était `agile`, pas les équipes ou la méthodologie. Et aussi, on a viré l'implicite qu'on n'avait pas sû identifier, les signataires étant très majoritairement des développeurs : un prérequis à faire du développement de logiciel agile, c'est l'excellence technique.

**_Tu ne tentes pas de faire du développement de logiciel agile sans l'excellence technique_** (architecturer le code pour qu'il soit évolutif et testable, avoir une stratégie de tests automatisés, déployer plusieurs fois par jour, écrire dans le code les mêmes mots que le domaine métier dans lequel tu t'inscris, tout ça). **_Sinon tu ne fais que mettre du stress sur ton équipe qui n'a pas les moyens de suivre le rythme sur la durée_** (Arnaud Lemaire en parle dans sa conférence [Et si on redémarrait l'agile?](https://www.youtube.com/watch?t=552&v=a-BOSpxYJ9M&feature=youtu.be))

### La naissance d'un nouveau mouvement de pensée : L'Artisanat du Logiciel (en anglais: Software Craftsmanship)

Au vu de ce qui s'était passé, et avec lequel aucun signataire n'était à l'aise avec, Uncle Bob lance l'idée de rajouter au manifeste agile une 5ème phrase:

> 1. `Individuals and interactions` over processes and tools
> 2. `Working software` over comprehensive documentation
> 3. `Customer collaboration` over contract negotiation
> 3. `Responding to change over` following a plan
> 5. **`Craftsmanship over crap`** qui plus tard, devint un peu moins dramatique : **_`Craftsmanship over Execution`_**

([source](https://www.infoq.com/news/2008/08/manifesto-fifth-craftsmanship/))

Cependant, l'idée d'amender quelque chose qui a été autant été élevé sur l'autel de la norme que le manifeste pour le développement Agile de logiciels n'a pas trouvé consensus chez les 17 signataires du manifeste, et on a donc... Créé un mouvement de pensée complémentaire, spécifiquement conçu pour expliciter le fameux implicite d'excellence technique:
> As aspiring Software Craftsmen we are raising the bar of professional software development by practicing it and helping others learn the craft. Through this work we have come to value:  
> * Not only `working software`, but also  **_well-crafted software_**
> * Not only `responding to change`, but also  **_steadily adding value_**
> * Not only `individuals and interactions`, but also  **_a community of professionals_**
> * Not only `customer collaboration`, but also **_productive partnerships_**
> 
> That is, in pursuit of the items on the left we have found the items on the right to be indispensable.

Et hop, nouveau mouvement de pensée créé : le **[Software Craftsmanship](https://manifesto.softwarecraftsmanship.org/)** (que les gens appellent communément... `le craft`).

Grosso modo, c'est:
* ET le mouvement de pensée du développement Agile de logiciels, sans se rater sur l'implicite de l'excellence technique
* ET un mouvement de pensée complétant le développement Agile de logiciels (en explicitant le pré-requis de l'excellence technique)

👇 Je rajoute également un petit nombre d'implicites connus (mais pas forcément totalement à jour) au sein du métier de développeur.

**Une personne issue d'école d'ingénieurs ou de développement logiciel, probablement :**
* ne sait pas faire/réfléchit pas à faire des tests automatisés
* ne sait pas faire/réfléchit pas à faire du code testable
* ne sait pas faire/réfléchit pas à faire de l'intégration continue
* est souvent accueilli en entreprise avec l'attente d'être un exécutant à qui on file des spécifications à implémenter
* est souvent l'objet d'attentes de travailler en tunnel (pour paralléliser et rendre l'équipe plus productive : eh oui, tout le monde a ses specs, donc ça devrait passer!)
* doit souvent s'engager sur des dates 

**Côté Software Craftsmanship, on va plutôt valoriser:**
* être impliqué dans la compréhension et l'établissement du besoin, afin de refléter au mieux ces derniers dans le code source qu'on écrit
* créer du code en ayant en tête la possibilité de devoir implémenter une architecture logicielle évolutive permettant de garder un temps de développement constant malgré le temps qui passe (et la base de code source qui grossit)
* l'automatisation et les échanges informels plutôt que les process rigides (par exemple, la mise en production et l'amélioration continue)
* l'établissement d'une responsabilité collective de l'équipe sur ce qui est délivré
* la collaboration/co-construction plus que la parallélisation des tâches car le développement de logiciels est une chose complexe, non-prédictive, et donc un enjeu majeur est le partage de connaissances (typiquement, "trier un jeu de cartes à 10 personnes" n'ira pas plus vite que "trier un jeu de cartes à 2 personnes")
* le fait de travailler de manière itérative: on cherche à 1) apprendre, puis 2) produire, dans cet ordre-là, car on sait que tant qu'on n'a rien implémenté, on est dans l'illusion et pas dans le réel dans toutes les réflexions qu'on est en train de faire

Je finis en disant qu'à côté du mouvement de pensée de l'`Artisanat du Logiciel`, ces termes peuvent également se référer à des notions plus génériques et/ou personnelles.

