import PropTypes from 'prop-types';
import React from 'react';

export default class HelloWorld extends React.Component {
  static propTypes = {
    name: PropTypes.string.isRequired,
  };

  constructor(props) {
    super(props);
    this.state = { name: this.props.name };
  }

  updateName = (name) => {
    this.setState({ name: name });
    console.log("here");
    var params = {search: "", type: ""};
    Rails.ajax({
      url: "/users.json",
      type: "get",
      data: $.param(params),
      beforeSend: function() {
        return true;
      },
      success: function (data) {
        console.log(data);
      },
      error: function (data) {
        console.log(data);
      }
    });
  };

  render() {
    return (
      <div>
        <h3>
          Hello, {this.state.name}!
        </h3>
        <hr />
        <form >
          <p>Also just want to look at the {this.props.course_organization}</p>
          <label htmlFor="name">
            Say hello to:
          </label>
          <input
            id="name"
            type="text"
            value={this.state.name}
            onChange={(e) => this.updateName(e.target.value)}
          />
        </form>
      </div>
    );
  }
}