#!/bin/bash
ROOT_USER_PASSWORD='$6$L9XlAcbPMHtOD4Q7$ruA1AHd4FLQ6pWlxVm7ay2yYrB7ZAzE3xJdE1EbuD9/IFv5YG/PTBBQpDWoQ0obhIq3n0Q2uUl8GR6RrJ2aBC/'
CREATE_NORMAL_USER=admin  ## Add the username here to create a user, leave empty to skip creating one
NORMAL_USER_PASSWORD='$6$L9XlAcbPMHtOD4Q7$ruA1AHd4FLQ6pWlxVm7ay2yYrB7ZAzE3xJdE1EbuD9/IFv5YG/PTBBQpDWoQ0obhIq3n0Q2uUl8GR6RrJ2aBC/'

## K3s configuration
MASTER_NODE_ADDR='master1.local'  ## The ip or FQDN of the first node
