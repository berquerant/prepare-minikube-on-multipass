#!/bin/bash

set -x

multipass stop "$INSTANCE_NAME"
multipass delete "$INSTANCE_NAME"
multipass purge
