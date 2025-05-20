## Holds all variables that need to be passed between scenes
extends Node

# settings
var masterVol = 75
var sfxVol = 75
var musicVol = 75

# progress
var xp = 0
var lvl = 0
var bittergems = 0
var unlocked = ["Solar Ray", "Bless"]
var equipped = ["Punch"]

# battle vars
var allSkills = []
var allRegions = []
var activeRegion
var affinityElement
var affinityModifier
var opponent
var playerMaxHealth = 20
var playerCurentHealth = 20
