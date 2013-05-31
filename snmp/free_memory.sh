#!/bin/bash

free | grep "^-/+ buffers/cache" | awk '{ print $4 }'
