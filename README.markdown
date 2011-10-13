# Little Checkin app

## Introduction

This application lets you manage a validation for the presence of people. People coming to work in a shared workspace can confirm their presence. Each person is given credit him allowing access to the shared workspace. The credits are provided by the administrators. Each worker can know who is on the shared workspace...

## Install App
  
### Prepare system

Make sure use RVM 

Install the good version of Ruby or modifiy .rvmrc

    rvm install ruby-1.9.2-p180
    
An best pratice for use rvm is create on gemset by app

    rvm gemset create checkin

### Grap source

Ok you can clone 

    git clone git@github.com:joel/checkin.git
    
Place in the project and trust .rvmrc file

    launch 'bundle install  --without production'
    
### Configuration

Rename database.sample.yml database.yml

    mv config/database.sample.yml config/database.yml

Rename and configure settings

    mv config/settings.sample.yml config/settings.yml

if you want activate the delegate autenticated please sign up on https://rpxnow.com and set APIKey

    rake db:migrate
 
make sure all work

Launch test unit and functional **#Deprecated**

    RAILS_ENV=test rake test #Deprecated
    
please use instead

    RAILS_ENV=test rake spec 
    
Launch cucumber test suite

    rake cucumber

or launch continue test integration

    watchr config/watchr.rb
    
And you can start the application
    
    rails s
    
Enjoy

  
