# Developer notes

The Poseidon framework is an entangled system of integrated software solutions. Changes in one part of the framework often have consequences for others. Especially changes to the most central component, the Poseidon standard, can have far-reaching ramifications.

```mermaid
flowchart TD
    
	%% comment

    packageDef["The Poseidon package definition"]

    poseidonYMLDef["POSEIDON.yml"]
	packageDef -- defines --> poseidonYMLDef

    genotypeDef["genotype data"]
	packageDef -- defines --> genotypeDef

	bibDef[".bib"]
	packageDef -- defines --> bibDef
    
    jannoDef[".janno"]
    packageDef -- defines --> jannoDef

    ssfDef[".ssf"]
    packageDef -- defines --> ssfDef

    poseidonAnalysisHS["poseidon-analysis-hs library"]
    poseidonHS --> poseidonAnalysisHS

    xerxes["xerxes"]
    poseidonAnalysisHS --> xerxes

    poseidonHS["poseidon-hs library"]
    poseidonYMLDef --> poseidonHS
	genotypeDef --> poseidonHS
	jannoDef --> poseidonHS
	bibDef --> poseidonHS
	ssfDef --> poseidonHS

    trident["trident"]
    poseidonHS --> trident

    api["Web API"]
    trident -- runs and uses --> api
	api --> explorer
    PCA --> api
    PMA --> api
    PAA --> api

    jannoR["janno R package"]
    jannoDef --> jannoR

    qjanno["qjanno"]
    jannoDef --> qjanno

    minotaur["Minotaur workflow"]
    jannoDef --> minotaur
	ssfDef --> minotaur

	PCA[(Community Archive)]
	trident -- validates --> PCA

	explorer[Repository explorer website]

	PMA[(Minotaur Archive)]
	minotaur -- generates --> PMA
	trident -- validates --> PMA

	PAA[(AADR Archive)]
	trident -- validates --> PAA

	website([Poseidon website])

```

New features or changes to the schema must be implemented in workable Pull Requests, and parallel Pull Requests should be opened in all derived repositories.

This includes the Poseidon website, which documents all components of the framework and thus most certainly requires an update if anything is changed.
