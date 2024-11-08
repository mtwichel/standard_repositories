#!/bin/sh

mason make github_actions_dart --on-conflict overwrite --exclude '' --minCoverage 0 --flutterVersion '3.24.1' --flutterChannel stable --dartChannel stable --dependabotFrequency monthly --generateDependabot false --generateSemanticPullRequest true --generateSpellCheck true --spellCheckConfig cspell.json --workflowRef main --generateLicenseCheck false