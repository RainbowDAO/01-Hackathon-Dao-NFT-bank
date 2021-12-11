import axios from "axios";
const REQUEST_TIMEOUT = 10000;
const MSG_TIMEOUT = 3 * 1000;
const SERVER_ADDRESS = 'static.edu.sdanshu.com'
const SERVER_PORT = 80;

const STATIC_ADDRESS = 'https://static.edu.sdanshu.com'
const RESOURCE_PORT = 8386;
// const BASE_URL = `http://${SERVER_ADDRESS}:${SERVER_PORT}`
const BASE_URL = 'http://www.rainbowchain.io/'
const headers = {
    // "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
    "Content-Type": "application/json",
};
export {
    STATIC_ADDRESS,
    BASE_URL
}
const axio = axios.create({
    baseURL: BASE_URL,
    headers
});

axio.defaults.timeout = REQUEST_TIMEOUT;

axio.interceptors.request.use(
    config => {
        // let token = localStorage.getItem('token')
        let token = sessionStorage.getItem("token");
        if (token) {
            config.headers.Authorization = "Bearer " + token;
        }
        if (config.url == "/login") {
            for (var k in config.headers) {
                if (k == "Authorization") {
                    delete config.headers[k];
                }
            }
        }
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);

axio.interceptors.response.use(
    response => {
        if (response.headers && response.headers.authorization) {
            let token = response.headers.authorization;
            if (token != "" && token != null) {
                headers.Authorization = token;
            }
        }
        if (response.headers && response.headers.uid) {
            localStorage.setItem("uid", response.headers.uid);
        }
        if (response.data && response.data.code == 401) {
            console.log("401");
            localStorage.removeItem("token");
            sessionStorage.removeItem('token')
            if (location.href.indexOf("/login") === -1) {
                location.href = "#/login?errorMsg=Please log in before operation";
            }
        } else if (response.data && response.data.code == 100001) {
            if (location.href.indexOf("/login") === -1) {
                location.href = "#/login?errorMsg=Please log in before operation";
            }
        }
        return response;
    },
    error => {
        console.log("request timeout");
        return Promise.reject(error);
    }
);

/**
 * Encapsulate get method
 * @param url
 * @param data
 * @returns {Promise}
 */

export function get(url, data) {
    return new Promise((resolve, reject) => {
        axio({
            method: "get",
            url,
            params: data,
            responseType: "json"
        })
            .then(response => {
                resolve(response.data);
            })
            .catch(error => {
                reject(error);
            });
    });
}

/**
 * Encapsulate post request
 * @param url
 * @param data
 * @returns {Promise}
 */

export function post(url, data) {
    return new Promise((resolve, reject) => {
        axio({
            method: "post",
            url,
            data,
            responseType: "json",
            headers: {
                "Content-Type": "application/json",
                Accept: "application/json"
            }
        })
            .then(response => {
                if (url == "/login") {
                    resolve(response);
                }
                resolve(response.data);
            })
            .catch(error => {
                reject(error);
            });
    });
}

/**
 * Encapsulate Petch requests
 * @param url
 * @param data
 * @returns {Promise}
 */

export function patch(url, data) {
    return new Promise((resolve, reject) => {
        axio({
            method: "patch",
            url,
            data,
            responseType: "json",
            headers: {
                "Content-Type": "application/json",
                Accept: "application/json"
            }
        })
            .then(response => {
                if (url == "/login") {
                    resolve(response);
                }
                resolve(response.data);
            })
            .catch(error => {
                reject(error);
            });
    });
}
/**
 * Encapsulate delete request
 * @param url
 * @param data
 * @returns {Promise}
 */

export function Delete(url, data) {
    return new Promise((resolve, reject) => {
        axio({
            method: "delete",
            url,
            data,
            responseType: "json",
            headers: {
                "Content-Type": "application/json",
                Accept: "application/json"
            }
        })
            .then(response => {
                if (url == "/login") {
                    resolve(response);
                }
                resolve(response.data);
            })
            .catch(error => {
                reject(error);
            });
    });
}
export {}
