import React from 'react';

class TripForm extends React.Component {
  constructor(props) {
    super(props);
  
    this.state = {
      title: "", state_date: "", end_date: "", location: "",
      creator_id: this.props.currentUserID
    }

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleUpdate(prop, e) {
    e.preventDefault();
    const value = e.currentTarget.value;

    this.setState({[prop]: value});
  }

  handleSubmit() {
    this.props.createTrip(this.props.currentUserID, this.state)
  }
  
  render() {
    const {handleUpdate, handleSubmit} = this;

    return(
      <div>
        <form onSubmit={handleSubmit}>
          <input type="text" 
            placeholder="Title"
            onChange={(e) => handleUpdate('title', e)}/>

          <input type="date" 
            onChange={(e) => handleUpdate('start_date', e)}/>

          <input type="date" 
            onChange={(e) => handleUpdate('end_date', e)}/>

          <input type="text"
            placeholder="Location"
            onChange={(e) => handleUpdate('location', e)}/>

          <input type="text"
            placeholder="Image Url"
            onChange={(e) => handleUpdate('image_url', e)}/>

          <input type="submit" value="Create Trip"/>
        </form>    
      </div>
    );
  }
}

export default TripForm;