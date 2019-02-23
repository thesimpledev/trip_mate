import { connect } from 'react-redux'
import TripShow from './tripShow'
import { selectTripById } from '../../../reducers/selectors'
import { deleteTrip } from '../../../actions/tripActions'

const mapStateToProps = (state, ownProps) => {
  return {trip: selectTripById(state, ownProps.match.params.id)}
}

const mapDispatchToProps = (dispatch) => {
  return {
    deleteTrip: (trip) => dispatch(deleteTrip(trip)),
    updateTrip: () => dispatch()
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(TripShow)