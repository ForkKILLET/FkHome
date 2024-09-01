import fs from 'node:fs/promises'
import path from 'node:path'
import url from 'node:url'
import twoFactor from 'node-2fa'

const getSecret = async () => {
	const env = process.env['SECRET_2FA']
	if (env) return env

	try {
		const file = path.join(url.fileURLToPath(import.meta.url), '../../2fa.txt')
        return await fs.readFile(file, 'utf-8')
	}
    catch {}
}

const secret = (await getSecret()).trim()

if (! secret) {
    console.error('Error: $SECRET_2FA not found')
    process.exit(1)
}

console.log('Token: %s', twoFactor.generateToken(secret).token)

