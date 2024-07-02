import fs from 'node:fs/promises'
import twoFactor from 'node-2fa'

const getSecret = async () => {
	const env = process.env['SECRET_2FA']
	if (env) return env

    try {
        return await fs.readFile('./2fa.txt', 'utf-8')
    }
    catch {
        return
    }
}

const secret = await getSecret()

if (! secret) {
    console.error('Error: $SECRET_2FA not found')
    process.exit(1)
}

console.log('Token: %s', twoFactor.generateToken(secret).token)

