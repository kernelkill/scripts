#!/bin/bash

tail -f /var/log/messages > out &

dialog                                         \
   --title 'Monitorando Mensagens do Sistema'  \
   --tailbox out                               \ 
   0 0
