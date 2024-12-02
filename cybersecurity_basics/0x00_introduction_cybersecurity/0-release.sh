#!/bin/bash
lsb_release -i | sed 's/Distributor ID:\s*//'
