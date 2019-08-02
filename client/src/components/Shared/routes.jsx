import React from 'react'
import { Switch, Route } from 'react-router-dom'

import Home from '../Pages/Home'
import About from '../Pages/About'
import TripIndexContainer from '../trips/index/tripIndexContainer'
import TripShowContainer from '../trips/show/tripShowContainer'
import TripNewContainer from '../trips/new/tripNewContainer'
import TripEditContainer from '../trips/edit/tripEditContainer'
import UsersIndexContainer from '../users/index/usersIndexContainer'
import SignUpContainer from '../users/signUpContainer'
import SignInContainer from '../sessions/signInContainer'

const selectRoutes = loggedIn => {
  if (loggedIn) {
    return <Switch>
      <Route path="/trips/:id/edit" component={ TripEditContainer } />
      <Route path="/trips/new" component={ TripNewContainer } exact />
      <Route path="/trips/:id" component={ TripShowContainer } />
      <Route path="/trips" component={ TripIndexContainer } />
      <Route path="/users" component={ UsersIndexContainer } />
      <Route path="/" component={ TripIndexContainer } />
    </Switch>
  } else {
    return <Switch>
      <Route path="/about" render={ About } />
      <Route path="/login" component={ SignInContainer } />
      <Route path="/signup" component={ SignUpContainer } />
      <Route path="/" render={ Home } />
    </Switch>
  }
}

const Routes = ({ loggedIn }) => {
  const routes = selectRoutes(loggedIn)

  return (
    <div className="container main">
      { routes }
    </div>
  )
}

export default Routes