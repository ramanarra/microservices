import {createParamDecorator, ExecutionContext, UnauthorizedException} from "@nestjs/common";

export const accountUsersSettingsWrite = createParamDecorator(
    (data: string, ctx: ExecutionContext) => {
        const request = ctx.switchToHttp().getRequest();
        const permissions = request.user.permissions;
        return permissions.indexOf('ACCOUNT_USERS_SETTINGS_WRITE') >= 0 ? true : false;
    }
);