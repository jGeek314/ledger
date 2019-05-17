import React, { Component } from 'react';
import { connect } from 'react-redux';

class LoginPage extends Component {
    render() {
        return (
            <div>
                <p className="text-info">
                    Welcome to <b>My Checkbook</b>!
                </p>
                <a className="btn btn-primary" href={process.env.REACT_APP_API_URL + '/auth/proxyLogin?startfb'}>
                    <i className="fa fa-facebook-square" /> Login with Facebook
                </a>
            </div>
        );
    }
}

export default LoginPage;
