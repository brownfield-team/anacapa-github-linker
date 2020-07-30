
import axios from "../helpers/axios-rails";
import ReactOnRails from "react-on-rails";

export default class GraphqlQuery {
    constructor(url,query,accept,callback) {
        this.csrf_token_fix();

        this.query = query;
        this.url = url;
        this.accept = accept;  
        this.callback = callback; 

        this.success = false;
        this.status = 0;
        this.status_message = "";
        this.data = {}
        this.error = {}
    }

    csrf_token_fix() {
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
    }

    async post(successFunc,failFunc) {
        const params = { 
            query: this.query,
            accept: this.accept
        };
        const self = this;

        return axios.post(self.url,params)
        .then(function (response) {
            // console.log(`axios.post then, response=${JSON.stringify(response)}`);
            self.success = true;
            self.data = response.data;
            self.status = response.status;
            self.status_message = response.statusText;
            self.callback(self);
        })
        .catch(function (error) {
            // console.log(`axios.post catch, error=${JSON.stringify(error)}`);
            self.success = false;
            self.data = {};
            self.status = error.response.status;
            self.status_message = error.response.statusText;
            self.callback(self);
        });
    }
}
