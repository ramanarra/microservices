"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
exports.__esModule = true;
exports.LoginDto = exports.UserDto = void 0;
var swagger_1 = require("@nestjs/swagger");
var UserDto = /** @class */ (function () {
    function UserDto() {
    }
    __decorate([
        swagger_1.ApiProperty({
            description: 'User name',
            type: String
        })
    ], UserDto.prototype, "name");
    __decorate([
        swagger_1.ApiProperty({
            description: 'User Email',
            type: String
        })
    ], UserDto.prototype, "email");
    __decorate([
        swagger_1.ApiProperty({
            description: 'User password',
            type: String,
            minLength: 5
        })
    ], UserDto.prototype, "password");
    __decorate([
        swagger_1.ApiProperty({
            description: 'Role Should be DOCTOR/PATIENT',
            type: String
        })
    ], UserDto.prototype, "role");
    return UserDto;
}());
exports.UserDto = UserDto;
var LoginDto = /** @class */ (function (_super) {
    __extends(LoginDto, _super);
    function LoginDto() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    return LoginDto;
}(swagger_1.OmitType(UserDto, ['name'])));
exports.LoginDto = LoginDto;
