import React from 'react'
import { Link } from 'react-router-dom'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Loader from '../../Shared/loader'
import TripIndexItemContainer from './tripIndexItemContainer'

class TripIndex extends React.Component {
  constructor(props) {
    super(props)
    this.state = {showForm: false, isLoading: true}
    this.toggleForm = this.toggleForm.bind(this)
  }

  componentDidMount() {
    this.props.retrieveMyTrips(this.props.currentUserID)
      .then(() => this.setState({isLoading: false}))
  }

  toggleForm() {
    this.setState({showForm: !this.state.showForm})
  }

  render() {
    if (this.state.isLoading) {
      return <Loader />
    }
    const {trips} = this.props

    return(
      <div>
        <div className="tripsIndex">
          <Link to="/trips/new" className="btn btn-success btn-sm">
            <FontAwesomeIcon icon="plus"/>
            New Trip
          </Link>

          <div className="tripIndexItems">
            {trips.map(trip => (
              <TripIndexItemContainer
                trip={trip}
                key={trip.id}/>
            ))}
          </div>
        </div>
      </div>
    )
  }
}

export default TripIndex